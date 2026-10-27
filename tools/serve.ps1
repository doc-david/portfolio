# Local static server for previewing the site (no Node/Python on this PC).
# Started from .claude/launch.json as "portfolio". Serves the site/ folder by default; pass -Root to serve another folder.
# Not part of the site; never deployed.
param([int]$Port = 8765, [string]$Root = (Join-Path $PSScriptRoot '..\site'))

$Root = (Resolve-Path $Root).Path
$mime = @{
  '.html' = 'text/html; charset=utf-8'; '.css' = 'text/css; charset=utf-8'
  '.js' = 'application/javascript'; '.json' = 'application/json'
  '.png' = 'image/png'; '.jpg' = 'image/jpeg'; '.jpeg' = 'image/jpeg'
  '.webp' = 'image/webp'; '.avif' = 'image/avif'; '.svg' = 'image/svg+xml'
  '.mp4' = 'video/mp4'; '.webm' = 'video/webm'; '.pdf' = 'application/pdf'
  '.woff2' = 'font/woff2'; '.ico' = 'image/x-icon'
}
$chunk = 1MB

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Start()
Write-Host "Serving $Root at http://localhost:$Port/"

while ($listener.IsListening) {
  $ctx = $listener.GetContext()
  $req = $ctx.Request
  $res = $ctx.Response
  $fs = $null
  try {
    $rel = [Uri]::UnescapeDataString($req.Url.AbsolutePath.TrimStart('/'))
    if ($rel -eq '' -or $rel.EndsWith('/')) { $rel += 'index.html' }
    $path = [IO.Path]::GetFullPath((Join-Path $Root $rel))
    if (-not $path.StartsWith($Root) -or -not (Test-Path -LiteralPath $path -PathType Leaf)) {
      $res.StatusCode = 404
      $body = [Text.Encoding]::UTF8.GetBytes('Not found')
      $res.OutputStream.Write($body, 0, $body.Length)
      continue
    }
    $ext = [IO.Path]::GetExtension($path).ToLower()
    $res.ContentType = if ($mime.ContainsKey($ext)) { $mime[$ext] } else { 'application/octet-stream' }
    $res.Headers.Add('Cache-Control', 'no-store')
    $res.Headers.Add('Accept-Ranges', 'bytes')

    $fs = [IO.File]::OpenRead($path)
    $len = $fs.Length
    $start = 0L
    $end = $len - 1
    # Serve byte ranges in capped chunks so one long video stream can't block this single-threaded loop
    if ($req.Headers['Range'] -match 'bytes=(\d*)-(\d*)') {
      if ($Matches[1]) { $start = [long]$Matches[1] }
      if ($Matches[2]) { $end = [long]$Matches[2] }
      $end = [Math]::Min([Math]::Min($end, $start + $chunk - 1), $len - 1)
      $res.StatusCode = 206
      $res.Headers.Add('Content-Range', "bytes $start-$end/$len")
    }
    $count = $end - $start + 1
    $res.ContentLength64 = $count
    if ($req.HttpMethod -ne 'HEAD') {
      [void]$fs.Seek($start, 'Begin')
      $buf = New-Object byte[] 65536
      while ($count -gt 0) {
        $n = $fs.Read($buf, 0, [int][Math]::Min($buf.Length, $count))
        if ($n -le 0) { break }
        $res.OutputStream.Write($buf, 0, $n)
        $count -= $n
      }
    }
  } catch {
    # Client aborted (common with video seeking); keep serving
  } finally {
    if ($fs) { $fs.Dispose() }
    try { $res.Close() } catch {}
  }
}

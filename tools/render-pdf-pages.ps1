param([string]$Pdf, [string]$OutDir, [string]$Prefix, [int]$Height = 1600, [long]$Quality = 86)
# Renders every PDF page with Windows.Data.Pdf, then saves each as a JPEG through System.Drawing.
Add-Type -AssemblyName System.Runtime.WindowsRuntime
Add-Type -AssemblyName System.Drawing
$null = [Windows.Storage.StorageFile, Windows.Storage, ContentType = WindowsRuntime]
$null = [Windows.Data.Pdf.PdfDocument, Windows.Data.Pdf, ContentType = WindowsRuntime]
$null = [Windows.Storage.Streams.InMemoryRandomAccessStream, Windows.Storage.Streams, ContentType = WindowsRuntime]

$asTaskOp = ([System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' })[0]
$asTaskAct = ([System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncAction' })[0]
function Wait-Op($op, [type]$t) { $task = $asTaskOp.MakeGenericMethod($t).Invoke($null, @($op)); $task.Wait(-1) | Out-Null; $task.Result }
function Wait-Act($act) { $task = $asTaskAct.Invoke($null, @($act)); $task.Wait(-1) | Out-Null }

New-Item -ItemType Directory -Force $OutDir | Out-Null
$file = Wait-Op ([Windows.Storage.StorageFile]::GetFileFromPathAsync($Pdf)) ([Windows.Storage.StorageFile])
$doc = Wait-Op ([Windows.Data.Pdf.PdfDocument]::LoadFromFileAsync($file)) ([Windows.Data.Pdf.PdfDocument])
$codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
$enc = New-Object System.Drawing.Imaging.EncoderParameters 1
$enc.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality), $Quality

for ($i = 0; $i -lt $doc.PageCount; $i++) {
  $page = $doc.GetPage($i)
  $opts = New-Object Windows.Data.Pdf.PdfPageRenderOptions
  $opts.DestinationHeight = $Height
  $opts.DestinationWidth = [uint32][math]::Round($Height * $page.Size.Width / $page.Size.Height)
  $ras = New-Object Windows.Storage.Streams.InMemoryRandomAccessStream
  Wait-Act ($page.RenderToStreamAsync($ras, $opts))
  $net = [System.IO.WindowsRuntimeStreamExtensions]::AsStreamForRead($ras.GetInputStreamAt(0))
  $bmp = New-Object System.Drawing.Bitmap $net
  $out = Join-Path $OutDir ('{0}{1:00}.jpg' -f $Prefix, ($i + 1))
  $bmp.Save($out, $codec, $enc)
  '{0} {1}x{2} {3:N0} KB' -f (Split-Path $out -Leaf), $bmp.Width, $bmp.Height, ((Get-Item $out).Length / 1KB)
  $bmp.Dispose(); $net.Dispose(); $page.Dispose()
}

param([string]$Pdf, [string]$Out, [int]$Width = 1300)
# Renders page 1 of a PDF to PNG with the Windows.Data.Pdf WinRT renderer.
Add-Type -AssemblyName System.Runtime.WindowsRuntime
Add-Type -AssemblyName System.Drawing
$null = [Windows.Storage.StorageFile, Windows.Storage, ContentType = WindowsRuntime]
$null = [Windows.Data.Pdf.PdfDocument, Windows.Data.Pdf, ContentType = WindowsRuntime]
$null = [Windows.Data.Pdf.PdfPageRenderOptions, Windows.Data.Pdf, ContentType = WindowsRuntime]
$null = [Windows.Storage.Streams.InMemoryRandomAccessStream, Windows.Storage.Streams, ContentType = WindowsRuntime]
$null = [Windows.Graphics.Imaging.BitmapEncoder, Windows.Graphics.Imaging, ContentType = WindowsRuntime]

$asTaskOp = [System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' } | Select-Object -First 1
$asTaskAction = [System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncAction' } | Select-Object -First 1
function Wait-Op($op, [type]$t) { $task = $asTaskOp.MakeGenericMethod($t).Invoke($null, @($op)); $task.Wait(-1) | Out-Null; $task.Result }
function Wait-Action($a) { $task = $asTaskAction.Invoke($null, @($a)); $task.Wait(-1) | Out-Null }

$file = Wait-Op ([Windows.Storage.StorageFile]::GetFileFromPathAsync($Pdf)) ([Windows.Storage.StorageFile])
$doc = Wait-Op ([Windows.Data.Pdf.PdfDocument]::LoadFromFileAsync($file)) ([Windows.Data.Pdf.PdfDocument])
"pages: $($doc.PageCount)"
$page = $doc.GetPage(0)
$h = [int][math]::Round($Width * $page.Size.Height / $page.Size.Width)
"page size (DIP): $($page.Size.Width) x $($page.Size.Height) -> $Width x $h"
$opts = New-Object Windows.Data.Pdf.PdfPageRenderOptions
$opts.DestinationWidth = $Width
$opts.DestinationHeight = $h
$opts.BitmapEncoderId = [Windows.Graphics.Imaging.BitmapEncoder]::PngEncoderId
$ras = New-Object Windows.Storage.Streams.InMemoryRandomAccessStream
Wait-Action ($page.RenderToStreamAsync($ras, $opts))
$ras.Seek(0)
$src = [System.IO.WindowsRuntimeStreamExtensions]::AsStreamForRead($ras)
$ms = New-Object System.IO.MemoryStream
$src.CopyTo($ms)
$ms.Position = 0
$bmp = [System.Drawing.Bitmap]::FromStream($ms)
"rendered: $($bmp.Width) x $($bmp.Height), corner pixel: $($bmp.GetPixel(2, 2))"
# Flatten onto white so the PNG has no transparency
$flat = New-Object System.Drawing.Bitmap $bmp.Width, $bmp.Height, ([System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
$g = [System.Drawing.Graphics]::FromImage($flat)
$g.Clear([System.Drawing.Color]::White)
$g.DrawImage($bmp, 0, 0, $bmp.Width, $bmp.Height)
$g.Dispose()
$flat.Save($Out, [System.Drawing.Imaging.ImageFormat]::Png)
$flat.Dispose(); $bmp.Dispose(); $ms.Dispose()
"saved: $Out ($((Get-Item $Out).Length) bytes)"

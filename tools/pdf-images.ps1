param([string]$Pdf, [string]$OutDir)
# Extracts DCTDecode image XObjects from a PDF; when an image has a FlateDecode gray SMask, writes a PNG with that alpha.
Add-Type -AssemblyName System.Drawing
$src = @"
using System;
using System.IO;
using System.IO.Compression;
using System.Text;
using System.Text.RegularExpressions;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;

public static class PdfImg {
  static byte[] data;
  static string text;
  static Dictionary<int,int> objAt = new Dictionary<int,int>();

  static string Dict(int obj) {
    int p = objAt[obj];
    int s = text.IndexOf("<<", p);
    int depth = 0; int i = s;
    while (i < text.Length) {
      if (text[i]=='<' && text[i+1]=='<') { depth++; i+=2; continue; }
      if (text[i]=='>' && text[i+1]=='>') { depth--; i+=2; if (depth==0) break; continue; }
      i++;
    }
    return Regex.Replace(text.Substring(s, i - s), "\\s+", " ");
  }
  static int IntVal(int obj) {
    int p = objAt[obj];
    var m = new Regex("obj\\s+(\\d+)").Match(text, p);
    return int.Parse(m.Groups[1].Value);
  }
  static byte[] Stream(int obj) {
    string d = Dict(obj);
    var lm = Regex.Match(d, "/Length (\\d+)( 0 R)?");
    int len = lm.Groups[2].Success ? IntVal(int.Parse(lm.Groups[1].Value)) : int.Parse(lm.Groups[1].Value);
    int p = text.IndexOf("stream", objAt[obj]);
    p += 6;
    if (data[p] == '\r') p++;
    if (data[p] == '\n') p++;
    byte[] b = new byte[len];
    Array.Copy(data, p, b, 0, len);
    return b;
  }
  static byte[] Inflate(byte[] z) {
    using (var ms = new MemoryStream(z, 2, z.Length - 2))
    using (var ds = new DeflateStream(ms, CompressionMode.Decompress))
    using (var o = new MemoryStream()) { ds.CopyTo(o); return o.ToArray(); }
  }
  public static string Run(string pdf, string outDir) {
    data = File.ReadAllBytes(pdf);
    text = Encoding.GetEncoding(28591).GetString(data);
    foreach (Match m in Regex.Matches(text, "(?<![0-9])(\\d+)\\s+0\\s+obj")) objAt[int.Parse(m.Groups[1].Value)] = m.Index;
    var sb = new StringBuilder();
    foreach (var kv in objAt) {
      string d;
      try { d = Dict(kv.Key); } catch { continue; }
      if (!d.Contains("/Subtype /Image") || !d.Contains("/DCTDecode")) continue;
      int w = int.Parse(Regex.Match(d, "/Width (\\d+)").Groups[1].Value);
      int h = int.Parse(Regex.Match(d, "/Height (\\d+)").Groups[1].Value);
      byte[] jpg = Stream(kv.Key);
      var sm = Regex.Match(d, "/SMask (\\d+) 0 R");
      string name = Path.Combine(outDir, "img-" + kv.Key.ToString("000"));
      if (!sm.Success) { File.WriteAllBytes(name + ".jpg", jpg); sb.AppendLine(kv.Key + " " + w + "x" + h + " jpg"); continue; }
      byte[] alpha = Inflate(Stream(int.Parse(sm.Groups[1].Value)));
      using (var bmp = new Bitmap(new MemoryStream(jpg)))
      using (var outB = new Bitmap(w, h, PixelFormat.Format32bppArgb)) {
        var src = bmp.LockBits(new Rectangle(0,0,w,h), ImageLockMode.ReadOnly, PixelFormat.Format32bppArgb);
        var dst = outB.LockBits(new Rectangle(0,0,w,h), ImageLockMode.WriteOnly, PixelFormat.Format32bppArgb);
        byte[] px = new byte[src.Stride * h];
        Marshal.Copy(src.Scan0, px, 0, px.Length);
        for (int y = 0; y < h; y++) for (int x = 0; x < w; x++) px[y * src.Stride + x * 4 + 3] = alpha[y * w + x];
        Marshal.Copy(px, 0, dst.Scan0, px.Length);
        bmp.UnlockBits(src); outB.UnlockBits(dst);
        outB.Save(name + ".png", ImageFormat.Png);
      }
      sb.AppendLine(kv.Key + " " + w + "x" + h + " png+alpha");
    }
    return sb.ToString();
  }
}
"@
Add-Type -TypeDefinition $src -ReferencedAssemblies System.Drawing
New-Item -ItemType Directory -Force $OutDir | Out-Null
[PdfImg]::Run($Pdf, $OutDir)

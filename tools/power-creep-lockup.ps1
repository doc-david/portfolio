param([string]$Pdf, [string]$Logo, [string]$Out, [int]$LogoWidth = 1000, [string]$Color = '#ffffff', [int]$Margin = 10)
# Rebuilds the Power Creep cover lockup: the title "Power Creep In", drawn from the PDF's own embedded Lexend Bold glyph outlines
# with the PDF's kerning, set above a clean logo at the cover's exact size and offset (all measured from the cover page's content stream).
Add-Type -AssemblyName System.Drawing
$cs = @"
using System; using System.IO; using System.IO.Compression; using System.Text; using System.Text.RegularExpressions;
using System.Collections.Generic; using System.Drawing; using System.Drawing.Drawing2D; using System.Drawing.Imaging; using System.Runtime.InteropServices;
public static class Lockup {
  static byte[] data; static string text;
  static int At(int obj) { return new Regex("(?<![0-9])" + obj + "\\s+0\\s+obj").Match(text).Index; }
  static byte[] Stream(int obj) {
    int p = At(obj); int d0 = text.IndexOf("<<", p), s0 = text.IndexOf("stream", d0);
    string dict = Regex.Replace(text.Substring(d0, s0 - d0), "\\s+", " ");
    var lm = Regex.Match(dict, "/Length (\\d+)( 0 R)?"); int len = int.Parse(lm.Groups[1].Value);
    if (lm.Groups[2].Success) len = int.Parse(new Regex("(?<![0-9])" + len + "\\s+0\\s+obj\\s+(\\d+)").Match(text).Groups[1].Value);
    int s = s0 + 6; if (data[s] == '\r') s++; if (data[s] == '\n') s++;
    using (var ms = new MemoryStream(data, s + 2, len - 2)) using (var ds = new DeflateStream(ms, CompressionMode.Decompress)) using (var o = new MemoryStream()) { ds.CopyTo(o); return o.ToArray(); }
  }
  static byte[] f; static Dictionary<string, int> tab = new Dictionary<string, int>();
  static int U16(int o) { return (f[o] << 8) | f[o + 1]; }
  static int S16(int o) { return (short)U16(o); }
  static int U32(int o) { return (f[o] << 24) | (f[o + 1] << 16) | (f[o + 2] << 8) | f[o + 3]; }
  static int GlyphOffset(int g, out int len) {
    bool longLoca = S16(tab["head"] + 50) == 1; int loca = tab["loca"];
    int a = longLoca ? U32(loca + g * 4) : U16(loca + g * 2) * 2;
    int b = longLoca ? U32(loca + g * 4 + 4) : U16(loca + g * 2 + 2) * 2;
    len = b - a; return tab["glyf"] + a;
  }
  static int Advance(int g) { int n = U16(tab["hhea"] + 34); return U16(tab["hmtx"] + 4 * Math.Min(g, n - 1)); }
  static void AddGlyph(GraphicsPath path, int g, float ox, float oy, float sc) {
    int len; int o = GlyphOffset(g, out len); if (len == 0) return;
    int nc = S16(o);
    if (nc < 0) { // composite: translate-only components
      int p = o + 10; while (true) {
        int flags = U16(p), gi = U16(p + 2); p += 4; int dx, dy;
        if ((flags & 1) != 0) { dx = S16(p); dy = S16(p + 2); p += 4; } else { dx = (sbyte)f[p]; dy = (sbyte)f[p + 1]; p += 2; }
        if ((flags & 8) != 0) p += 2; else if ((flags & 0x40) != 0) p += 4; else if ((flags & 0x80) != 0) p += 8;
        AddGlyph(path, gi, ox + dx * sc, oy - dy * sc, sc);
        if ((flags & 0x20) == 0) break;
      }
      return;
    }
    int[] ends = new int[nc]; for (int i = 0; i < nc; i++) ends[i] = U16(o + 10 + i * 2);
    int np = nc == 0 ? 0 : ends[nc - 1] + 1; int q = o + 10 + nc * 2; q += 2 + U16(q);
    byte[] fl = new byte[np]; for (int i = 0; i < np; ) { byte b = f[q++]; fl[i++] = b; if ((b & 8) != 0) { int r = f[q++]; while (r-- > 0) fl[i++] = b; } }
    int[] xs = new int[np], ys = new int[np]; int v = 0;
    for (int i = 0; i < np; i++) { if ((fl[i] & 2) != 0) { int d = f[q++]; v += (fl[i] & 16) != 0 ? d : -d; } else if ((fl[i] & 16) == 0) { v += S16(q); q += 2; } xs[i] = v; }
    v = 0;
    for (int i = 0; i < np; i++) { if ((fl[i] & 4) != 0) { int d = f[q++]; v += (fl[i] & 32) != 0 ? d : -d; } else if ((fl[i] & 32) == 0) { v += S16(q); q += 2; } ys[i] = v; }
    int start = 0;
    for (int c = 0; c < nc; c++) {
      int end = ends[c], n = end - start + 1;
      Func<int, PointF> P = k => new PointF(ox + xs[start + k] * sc, oy - ys[start + k] * sc);
      Func<int, bool> On = k => (fl[start + k] & 1) != 0;
      // start at an on-curve point, or the midpoint of two off-curve points
      int s0 = -1; for (int k = 0; k < n; k++) if (On(k)) { s0 = k; break; }
      PointF first = s0 >= 0 ? P(s0) : new PointF((P(0).X + P(n - 1).X) / 2, (P(0).Y + P(n - 1).Y) / 2);
      if (s0 < 0) s0 = 0; // all off-curve: start between last and first
      path.StartFigure(); PointF cur = first; PointF? ctrl = null;
      for (int step = 1; step <= n; step++) {
        int k = (s0 + step) % n; PointF pt = P(k);
        if (On(k)) {
          if (ctrl.HasValue) { Quad(path, cur, ctrl.Value, pt); ctrl = null; } else path.AddLine(cur, pt);
          cur = pt;
        } else {
          if (ctrl.HasValue) { var mid = new PointF((ctrl.Value.X + pt.X) / 2, (ctrl.Value.Y + pt.Y) / 2); Quad(path, cur, ctrl.Value, mid); cur = mid; }
          ctrl = pt;
        }
      }
      if (ctrl.HasValue) Quad(path, cur, ctrl.Value, first);
      path.CloseFigure(); start = end + 1;
    }
  }
  static void Quad(GraphicsPath path, PointF a, PointF c, PointF b) {
    var c1 = new PointF(a.X + 2f / 3 * (c.X - a.X), a.Y + 2f / 3 * (c.Y - a.Y));
    var c2 = new PointF(b.X + 2f / 3 * (c.X - b.X), b.Y + 2f / 3 * (c.Y - b.Y));
    path.AddBezier(a, c1, c2, b);
  }
  // Reads the first TJ array shown with the given font resource: a list of CIDs and kerning numbers
  static List<object> ReadTJ(byte[] content, string fontRes) {
    string s = Encoding.GetEncoding(28591).GetString(content);
    int i = s.IndexOf(fontRes); i = s.IndexOf('[', i); var items = new List<object>(); i++;
    while (s[i] != ']') {
      char ch = s[i];
      if (ch == '(') {
        var bytes = new List<byte>(); i++; int depth = 1;
        while (true) {
          char c = s[i];
          if (c == '\\') { char e = s[i + 1];
            if (e >= '0' && e <= '7') { int val = 0, k = 0; while (k < 3 && s[i + 1 + k] >= '0' && s[i + 1 + k] <= '7') { val = val * 8 + (s[i + 1 + k] - '0'); k++; } bytes.Add((byte)val); i += 1 + k; continue; }
            if (e == 'n') bytes.Add(10); else if (e == 'r') bytes.Add(13); else if (e == 't') bytes.Add(9); else if (e == 'b') bytes.Add(8); else if (e == 'f') bytes.Add(12);
            else if (e == '\r' || e == '\n') { } else bytes.Add((byte)e);
            i += 2; continue; }
          if (c == '(') depth++; if (c == ')') { depth--; if (depth == 0) { i++; break; } }
          bytes.Add((byte)c); i++;
        }
        for (int k = 0; k + 1 < bytes.Count; k += 2) items.Add((bytes[k] << 8) | bytes[k + 1]);
      } else if (ch == '-' || ch == '.' || char.IsDigit(ch)) {
        int j = i; while (s[j] == '-' || s[j] == '.' || char.IsDigit(s[j])) j++;
        items.Add(double.Parse(s.Substring(i, j - i), System.Globalization.CultureInfo.InvariantCulture)); i = j;
      } else i++;
    }
    return items;
  }
  public static string Run(string pdf, string logoPath, string outPath, int logoW, string color, int margin) {
    data = File.ReadAllBytes(pdf); text = Encoding.GetEncoding(28591).GetString(data);
    f = Stream(95); int nt = U16(4);
    for (int i = 0; i < nt; i++) tab[Encoding.ASCII.GetString(f, 12 + i * 16, 4)] = U32(12 + i * 16 + 8);
    int upm = U16(tab["head"] + 18);
    var tj = ReadTJ(Stream(6), "/Font4");
    // Cover geometry, in the page's 1/508pt units (from page 1's content stream and the logo's box in the cover screenshot)
    double coverLogoLeft = 35391, coverLogoTop = 111377, coverLogoW = 230773;
    double textX = 68129.9, textBase = 105518.6, fontSize = 17576.8;
    // Logo: trim to its visible pixels
    Bitmap src = new Bitmap(logoPath); Rectangle bb = AlphaBox(src);
    double k = logoW / coverLogoW; int logoH = (int)Math.Round(bb.Height * (double)logoW / bb.Width);
    float sc = (float)(fontSize * k / upm);
    float ox = (float)((textX - coverLogoLeft) * k), oy = (float)((textBase - coverLogoTop) * k);
    var path = new GraphicsPath(FillMode.Winding); float x = ox; var cids = new StringBuilder();
    foreach (var it in tj) {
      if (it is int) { int g = (int)it; AddGlyph(path, g, x, oy, sc); x += Advance(g) * sc; cids.Append(g + " "); }
      else x -= (float)((double)it / 1000 * fontSize * k);
    }
    RectangleF tb = path.GetBounds();
    float left = Math.Min(0, tb.Left), top = Math.Min(0, tb.Top), right = Math.Max(logoW, tb.Right), bottom = Math.Max(logoH, tb.Bottom);
    int W = (int)Math.Ceiling(right - left) + 2 * margin, H = (int)Math.Ceiling(bottom - top) + 2 * margin;
    float dx = margin - left, dy = margin - top;
    using (var outB = new Bitmap(W, H, PixelFormat.Format32bppArgb)) using (var g2 = Graphics.FromImage(outB)) {
      g2.Clear(Color.Transparent); g2.SmoothingMode = SmoothingMode.AntiAlias; g2.InterpolationMode = InterpolationMode.HighQualityBicubic;
      g2.PixelOffsetMode = PixelOffsetMode.HighQuality; g2.CompositingQuality = CompositingQuality.HighQuality;
      using (var ia = new ImageAttributes()) { ia.SetWrapMode(WrapMode.TileFlipXY);
        g2.DrawImage(src, new Rectangle((int)Math.Round(dx), (int)Math.Round(dy), logoW, logoH), bb.X, bb.Y, bb.Width, bb.Height, GraphicsUnit.Pixel, ia); }
      var m = new Matrix(); m.Translate(dx, dy); path.Transform(m);
      using (var br = new SolidBrush(ColorTranslator.FromHtml(color))) g2.FillPath(br, path);
      outB.Save(outPath, ImageFormat.Png);
    }
    return string.Format("upm {0}; glyphs {1}; logo src box {2}; out {3}x{4}; logo {5}x{6} at {7:0},{8:0}; text box {9:0},{10:0} {11:0}x{12:0}",
      upm, cids, bb, W, H, logoW, logoH, dx, dy, tb.X + dx, tb.Y + dy, tb.Width, tb.Height);
  }
  static Rectangle AlphaBox(Bitmap b) {
    var d = b.LockBits(new Rectangle(0, 0, b.Width, b.Height), ImageLockMode.ReadOnly, PixelFormat.Format32bppArgb);
    byte[] p = new byte[d.Stride * b.Height]; Marshal.Copy(d.Scan0, p, 0, p.Length); b.UnlockBits(d);
    int x0 = b.Width, y0 = b.Height, x1 = -1, y1 = -1;
    for (int y = 0; y < b.Height; y++) for (int x = 0; x < b.Width; x++) if (p[y * d.Stride + x * 4 + 3] > 8) { if (x < x0) x0 = x; if (x > x1) x1 = x; if (y < y0) y0 = y; if (y > y1) y1 = y; }
    return Rectangle.FromLTRB(x0, y0, x1 + 1, y1 + 1);
  }
}
"@
Add-Type -TypeDefinition $cs -ReferencedAssemblies System.Drawing
[Lockup]::Run($Pdf, $Logo, $Out, $LogoWidth, $Color, $Margin)

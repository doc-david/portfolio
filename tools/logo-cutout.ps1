param([string]$Src, [string]$Out, [int]$X, [int]$Y, [int]$W, [int]$H, [int]$HoleMaxY = 0, [int[]]$Clear = @(0,0,0,0))
# Cuts a logo off a light background: flood-fills the light, low-saturation pixels reachable from the crop edge,
# makes them transparent, unmixes the background color out of a 2px band around them, then trims to the art plus 10px.
Add-Type -AssemblyName System.Drawing
$cs = @"
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;
public static class Cutout {
  public static string Run(string src, string outPath, int cx, int cy, int cw, int ch, int holeMaxY, int clrX, int clrY, int clrW, int clrH) {
    using (var full = new Bitmap(src))
    using (var crop = full.Clone(new Rectangle(cx, cy, cw, ch), PixelFormat.Format32bppArgb)) {
      int w = cw, h = ch;
      var bd = crop.LockBits(new Rectangle(0,0,w,h), ImageLockMode.ReadWrite, PixelFormat.Format32bppArgb);
      int st = bd.Stride; byte[] p = new byte[st * h];
      Marshal.Copy(bd.Scan0, p, 0, p.Length);
      Func<int,int,int> I = (x, y) => y * st + x * 4;
      Func<int,int,bool> bgLike = (x, y) => {
        int i = I(x, y); int b = p[i], g = p[i+1], r = p[i+2];
        int mn = Math.Min(r, Math.Min(g, b)), mx = Math.Max(r, Math.Max(g, b));
        return mn > 196 && mx - mn < 34;
      };
      var bg = new bool[w * h];
      var q = new Queue<int>();
      for (int x = 0; x < w; x++) { q.Enqueue(x); q.Enqueue((h - 1) * w + x); }
      for (int y = 0; y < h; y++) { q.Enqueue(y * w); q.Enqueue(y * w + w - 1); }
      while (q.Count > 0) {
        int k = q.Dequeue(); if (bg[k]) continue;
        int x = k % w, y = k / w; if (!bgLike(x, y)) continue;
        bg[k] = true;
        if (x > 0) q.Enqueue(k - 1); if (x < w - 1) q.Enqueue(k + 1);
        if (y > 0) q.Enqueue(k - w); if (y < h - 1) q.Enqueue(k + w);
      }
      // Enclosed light holes (letter counters) above holeMaxY are background too; below it, enclosed light pixels are artwork (white type on a banner)
      var seen = new bool[w * h];
      for (int s0 = 0; s0 < w * h; s0++) {
        if (bg[s0] || seen[s0] || !bgLike(s0 % w, s0 / w)) continue;
        var comp = new List<int>(); var q2 = new Queue<int>(); q2.Enqueue(s0); seen[s0] = true;
        long sy = 0;
        while (q2.Count > 0) {
          int k = q2.Dequeue(); comp.Add(k); sy += k / w;
          int x = k % w, y = k / w;
          int[] nb = { x > 0 ? k - 1 : -1, x < w - 1 ? k + 1 : -1, y > 0 ? k - w : -1, y < h - 1 ? k + w : -1 };
          foreach (int j in nb) if (j >= 0 && !seen[j] && !bg[j] && bgLike(j % w, j / w)) { seen[j] = true; q2.Enqueue(j); }
        }
        if (sy / comp.Count < holeMaxY && comp.Count >= 12) foreach (int k in comp) bg[k] = true;
      }
      // Cleared rectangle: stray artwork that isn't part of the logo
      for (int y = clrY; y < Math.Min(h, clrY + clrH); y++) for (int x = clrX; x < Math.Min(w, clrX + clrW); x++) bg[y * w + x] = true;
      // Background color: the mean of the filled pixels
      double sr = 0, sg = 0, sb = 0; int n = 0;
      for (int k = 0; k < w * h; k++) if (bg[k]) { int i = I(k % w, k / w); sb += p[i]; sg += p[i+1]; sr += p[i+2]; n++; }
      double[] bgc = { sb / n, sg / n, sr / n };
      // Distance (in px, chessboard) from the background region, capped at 3
      var dist = new int[w * h];
      for (int k = 0; k < w * h; k++) dist[k] = bg[k] ? 0 : 99;
      for (int pass = 0; pass < 3; pass++)
        for (int y = 0; y < h; y++) for (int x = 0; x < w; x++) {
          int k = y * w + x; if (dist[k] <= pass) continue;
          for (int dy = -1; dy <= 1; dy++) for (int dx = -1; dx <= 1; dx++) {
            int xx = x + dx, yy = y + dy; if (xx < 0 || yy < 0 || xx >= w || yy >= h) continue;
            if (dist[yy * w + xx] == pass) dist[k] = Math.Min(dist[k], pass + 1);
          }
        }
      int minX = w, minY = h, maxX = 0, maxY = 0;
      for (int y = 0; y < h; y++) for (int x = 0; x < w; x++) {
        int k = y * w + x, i = I(x, y);
        double a;
        if (bg[k]) a = 0;
        else if (dist[k] <= 2) {
          a = 0;
          for (int c = 0; c < 3; c++) {
            double v = p[i + c], b0 = bgc[c];
            double ac = v > b0 ? (v - b0) / (255 - b0) : (b0 - v) / b0;
            if (ac > a) a = ac;
          }
          a = Math.Min(1, a);
        } else a = 1;
        if (a > 0 && a < 1) for (int c = 0; c < 3; c++) {
          double v = (p[i + c] - bgc[c]) / a + bgc[c];
          p[i + c] = (byte)Math.Max(0, Math.Min(255, Math.Round(v)));
        }
        p[i + 3] = (byte)Math.Round(a * 255);
        if (a > 0.04) { if (x < minX) minX = x; if (x > maxX) maxX = x; if (y < minY) minY = y; if (y > maxY) maxY = y; }
      }
      Marshal.Copy(p, 0, bd.Scan0, p.Length);
      crop.UnlockBits(bd);
      int m = 10;
      var r2 = Rectangle.FromLTRB(Math.Max(0, minX - m), Math.Max(0, minY - m), Math.Min(w, maxX + 1 + m), Math.Min(h, maxY + 1 + m));
      using (var trimmed = crop.Clone(r2, PixelFormat.Format32bppArgb)) trimmed.Save(outPath, ImageFormat.Png);
      return string.Format("bg rgb({0:0},{1:0},{2:0}); trimmed {3}x{4} at {5},{6}; edge touched: L{7} T{8} R{9} B{10}",
        bgc[2], bgc[1], bgc[0], r2.Width, r2.Height, r2.X, r2.Y, minX <= 0, minY <= 0, maxX >= w - 1, maxY >= h - 1);
    }
  }
}
"@
Add-Type -TypeDefinition $cs -ReferencedAssemblies System.Drawing
[Cutout]::Run($Src, $Out, $X, $Y, $W, $H, $HoleMaxY, $Clear[0], $Clear[1], $Clear[2], $Clear[3])

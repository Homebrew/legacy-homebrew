require "formula"

class Ctlib < Formula
  homepage "http://ctl.appliedtopology.org"
  url "http://ctl.appliedtopology.org/r/v0.1.tgz"
  sha1 "9c8ad348c1760a3646cc454b1e9cb66b695d58f6"

  depends_on "cmake" => :build
  depends_on "tbb"
  depends_on "boost"
  depends_on "metis"
  #broken ifdef in v0.1 with SSE4.2 enabled. fixed for next release
  #for now we apply this patch.
  patch :DATA

  def install
     args = std_cmake_args
     args << "-DCXXFLAGS=-mmacosx-version-min"
     system "cmake", *args
     system "make VERBOSE=1"
     system "make install"
     bin.install Dir["bin/*"]
     man1.install Dir["man/*"]
     include.install Dir["include/*"]
     doc.install Dir["doc/*"]
     share.install Dir["examples/*"]
  end
end
__END__
diff --git a/ctl/hash/city.h b/ctl/hash/city.h
index 3cf3dde..39d7f01 100644
--- a/ctl/hash/city.h
+++ b/ctl/hash/city.h
@@ -533,9 +533,8 @@ uint128 CityHash128(const char *s, size_t len) {
                           uint128(Fetch64(s), Fetch64(s + 8) + k0)) :
       CityHash128WithSeed(s, len, uint128(k0, k1));
 }
-
 #ifdef __SSE4_2__
-#include <citycrc.h>
+//RHL: Begin insert declarations from city.
 #include <nmmintrin.h>
 
 // Requires len >= 240.
@@ -642,6 +641,142 @@ void CityHashCrc256(const char *s, size_t len, uint64 *result) {
   }
 }
 
+uint128 CityHashCrc128(const char *s, size_t len) {
+  if (len <= 900) {
+    return CityHash128(s, len);
+  } else {
+    uint64 result[4];
+    CityHashCrc256(s, len, result);
+    return uint128(result[2], result[3]);
+  }
+}
+
+uint128 CityHashCrc128WithSeed(const char *s, size_t len, uint128 seed) {
+  if (len <= 900) {
+    return CityHash128WithSeed(s, len, seed);
+  } else {
+    uint64 result[4];
+    CityHashCrc256(s, len, result);
+    uint64 u = Uint128High64(seed) + result[0];
+    uint64 v = Uint128Low64(seed) + result[1];
+    return uint128(HashLen16(u, v + result[2]),
+                   HashLen16(Rotate(v, 32), u * k0 + result[3]));
+  }
+}
+
+
+
+
+
+
+
+//END insert declarations
+
+
+
+
+/*
+// Requires len >= 240.
+static void CityHashCrc256Long(const char *s, size_t len,
+                               uint32 seed, uint64 *result) {
+  uint64 a = Fetch64(s + 56) + k0;
+  uint64 b = Fetch64(s + 96) + k0;
+  uint64 c = result[0] = HashLen16(b, len);
+  uint64 d = result[1] = Fetch64(s + 120) * k0 + len;
+  uint64 e = Fetch64(s + 184) + seed;
+  uint64 f = 0;
+  uint64 g = 0;
+  uint64 h = c + d;
+  uint64 x = seed;
+  uint64 y = 0;
+  uint64 z = 0;
+
+  // 240 bytes of input per iter.
+  size_t iters = len / 240;
+  len -= iters * 240;
+  do {
+#undef CHUNK
+#define CHUNK(r)                                \
+    PERMUTE3(x, z, y);                          \
+    b += Fetch64(s);                            \
+    c += Fetch64(s + 8);                        \
+    d += Fetch64(s + 16);                       \
+    e += Fetch64(s + 24);                       \
+    f += Fetch64(s + 32);                       \
+    a += b;                                     \
+    h += f;                                     \
+    b += c;                                     \
+    f += d;                                     \
+    g += e;                                     \
+    e += z;                                     \
+    g += x;                                     \
+    z = _mm_crc32_u64(z, b + g);                \
+    y = _mm_crc32_u64(y, e + h);                \
+    x = _mm_crc32_u64(x, f + a);                \
+    e = Rotate(e, r);                           \
+    c += e;                                     \
+    s += 40
+
+    CHUNK(0); PERMUTE3(a, h, c);
+    CHUNK(33); PERMUTE3(a, h, f);
+    CHUNK(0); PERMUTE3(b, h, f);
+    CHUNK(42); PERMUTE3(b, h, d);
+    CHUNK(0); PERMUTE3(b, h, e);
+    CHUNK(33); PERMUTE3(a, h, e);
+  } while (--iters > 0);
+
+  while (len >= 40) {
+    CHUNK(29);
+    e ^= Rotate(a, 20);
+    h += Rotate(b, 30);
+    g ^= Rotate(c, 40);
+    f += Rotate(d, 34);
+    PERMUTE3(c, h, g);
+    len -= 40;
+  }
+  if (len > 0) {
+    s = s + len - 40;
+    CHUNK(33);
+    e ^= Rotate(a, 43);
+    h += Rotate(b, 42);
+    g ^= Rotate(c, 41);
+    f += Rotate(d, 40);
+  }
+  result[0] ^= h;
+  result[1] ^= g;
+  g += h;
+  a = HashLen16(a, g + z);
+  x += y << 32;
+  b += x;
+  c = HashLen16(c, z) + h;
+  d = HashLen16(d, e + result[0]);
+  g += e;
+  h += HashLen16(x, f);
+  e = HashLen16(a, d) + g;
+  z = HashLen16(b, c) + a;
+  y = HashLen16(g, h) + c;
+  result[0] = e + z + y + x;
+  a = ShiftMix((a + y) * k0) * k0 + b;
+  result[1] += a + result[0];
+  a = ShiftMix(a * k0) * k0 + c;
+  result[2] = a + result[1];
+  a = ShiftMix((a + e) * k0) * k0;
+  result[3] = a + result[2];
+}
+// Requires len < 240.
+static void CityHashCrc256Short(const char *s, size_t len, uint64 *result) {
+  char buf[240];
+  std::memcpy(buf, s, len);
+  std::memset(buf + len, 0, 240 - len);
+  CityHashCrc256Long(buf, 240, ~static_cast<uint32>(len), result);
+}
+void CityHashCrc256(const char *s, size_t len, uint64 *result) {
+  if (LIKELY(len >= 240)) {
+    CityHashCrc256Long(s, len, 0, result);
+  } else {
+    CityHashCrc256Short(s, len, result);
+  }
+}
 uint128 CityHashCrc128WithSeed(const char *s, size_t len, uint128 seed) {
   if (len <= 900) {
     return CityHash128WithSeed(s, len, seed);
@@ -664,5 +799,5 @@ uint128 CityHashCrc128(const char *s, size_t len) {
     return uint128(result[2], result[3]);
   }
 }
-
+*/
 #endif

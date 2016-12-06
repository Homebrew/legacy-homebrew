require 'formula'

class Bwa < Formula
  homepage 'http://bio-bwa.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/bio-bwa/bwa-0.6.2.tar.bz2'
  sha1 'fd3d0666a89d189b642d6f1c4cfa9c29123c12bc'

  head 'https://github.com/lh3/bwa.git'

  # These inline functions cause undefined symbol errors with CLANG.
  # Fixed upstream for next release. See:
  # https://github.com/lh3/bwa/pull/11
  def patches; DATA; end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "bwa"
    man1.install "bwa.1"
  end
end

__END__
diff --git a/bwt.c b/bwt.c
index fcc141e..966b718 100644
--- a/bwt.c
+++ b/bwt.c
@@ -95,7 +95,7 @@ static inline int __occ_aux(uint64_t y, int c)
	return ((y + (y >> 4)) & 0xf0f0f0f0f0f0f0full) * 0x101010101010101ull >> 56;
 }

-inline bwtint_t bwt_occ(const bwt_t *bwt, bwtint_t k, ubyte_t c)
+bwtint_t bwt_occ(const bwt_t *bwt, bwtint_t k, ubyte_t c)
 {
	bwtint_t n, l, j;
	uint32_t *p;
@@ -121,7 +121,7 @@ inline bwtint_t bwt_occ(const bwt_t *bwt, bwtint_t k, ubyte_t c)
 }

 // an analogy to bwt_occ() but more efficient, requiring k <= l
-inline void bwt_2occ(const bwt_t *bwt, bwtint_t k, bwtint_t l, ubyte_t c, bwtint_t *ok, bwtint_t *ol)
+void bwt_2occ(const bwt_t *bwt, bwtint_t k, bwtint_t l, ubyte_t c, bwtint_t *ok, bwtint_t *ol)
 {
	bwtint_t _k, _l;
	_k = (k >= bwt->primary)? k-1 : k;
@@ -158,7 +158,7 @@ inline void bwt_2occ(const bwt_t *bwt, bwtint_t k, bwtint_t l, ubyte_t c, bwtint
	((bwt)->cnt_table[(b)&0xff] + (bwt)->cnt_table[(b)>>8&0xff]		\
	 + (bwt)->cnt_table[(b)>>16&0xff] + (bwt)->cnt_table[(b)>>24])

-inline void bwt_occ4(const bwt_t *bwt, bwtint_t k, bwtint_t cnt[4])
+void bwt_occ4(const bwt_t *bwt, bwtint_t k, bwtint_t cnt[4])
 {
	bwtint_t l, j, x;
	uint32_t *p;
@@ -178,7 +178,7 @@ inline void bwt_occ4(const bwt_t *bwt, bwtint_t k, bwtint_t cnt[4])
 }

 // an analogy to bwt_occ4() but more efficient, requiring k <= l
-inline void bwt_2occ4(const bwt_t *bwt, bwtint_t k, bwtint_t l, bwtint_t cntk[4], bwtint_t cntl[4])
+void bwt_2occ4(const bwt_t *bwt, bwtint_t k, bwtint_t l, bwtint_t cntk[4], bwtint_t cntl[4])
 {
	bwtint_t _k, _l;
	_k = (k >= bwt->primary)? k-1 : k;
diff --git a/bwt_lite.c b/bwt_lite.c
index dd411e1..902e0fc 100644
--- a/bwt_lite.c
+++ b/bwt_lite.c
@@ -65,7 +65,7 @@ inline uint32_t bwtl_occ(const bwtl_t *bwt, uint32_t k, uint8_t c)
	if (c == 0) n -= 15 - (k&15); // corrected for the masked bits
	return n;
 }
-inline void bwtl_occ4(const bwtl_t *bwt, uint32_t k, uint32_t cnt[4])
+void bwtl_occ4(const bwtl_t *bwt, uint32_t k, uint32_t cnt[4])
 {
	uint32_t x, b;
	if (k == (uint32_t)(-1)) {
@@ -80,7 +80,7 @@ inline void bwtl_occ4(const bwtl_t *bwt, uint32_t k, uint32_t cnt[4])
	x -= 15 - (k&15);
	cnt[0] += x&0xff; cnt[1] += x>>8&0xff; cnt[2] += x>>16&0xff; cnt[3] += x>>24;
 }
-inline void bwtl_2occ4(const bwtl_t *bwt, uint32_t k, uint32_t l, uint32_t cntk[4], uint32_t cntl[4])
+void bwtl_2occ4(const bwtl_t *bwt, uint32_t k, uint32_t l, uint32_t cntk[4], uint32_t cntl[4])
 {
	bwtl_occ4(bwt, k, cntk);
	bwtl_occ4(bwt, l, cntl);

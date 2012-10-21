require 'formula'

class Jasper < Formula
  homepage 'http://www.ece.uvic.ca/~frodo/jasper/'
  url 'http://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.1.zip'
  sha1 '9c5735f773922e580bf98c7c7dfda9bbed4c5191'

  option :universal

  depends_on 'jpeg'

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  # The following patch fixes a bug (still in upstream as of jasper 1.900.1)
  # where an assertion fails when Jasper is fed certain JPEG-2000 files with
  # an alpha channel. See:
  # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=469786
  def patches; DATA; end

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-shared",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end

__END__
diff --git a/src/libjasper/jpc/jpc_dec.c b/src/libjasper/jpc/jpc_dec.c
index fa72a0e..1f4845f 100644
--- a/src/libjasper/jpc/jpc_dec.c
+++ b/src/libjasper/jpc/jpc_dec.c
@@ -1069,12 +1069,18 @@ static int jpc_dec_tiledecode(jpc_dec_t *dec, jpc_dec_tile_t *tile)
	/* Apply an inverse intercomponent transform if necessary. */
	switch (tile->cp->mctid) {
	case JPC_MCT_RCT:
-		assert(dec->numcomps == 3);
+		if (dec->numcomps != 3 && dec->numcomps != 4) {
+			jas_eprintf("bad number of components (%d)\n", dec->numcomps);
+			return -1;
+		}
		jpc_irct(tile->tcomps[0].data, tile->tcomps[1].data,
		  tile->tcomps[2].data);
		break;
	case JPC_MCT_ICT:
-		assert(dec->numcomps == 3);
+		if (dec->numcomps != 3 && dec->numcomps != 4) {
+			jas_eprintf("bad number of components (%d)\n", dec->numcomps);
+			return -1;
+		}
		jpc_iict(tile->tcomps[0].data, tile->tcomps[1].data,
		  tile->tcomps[2].data);
		break;

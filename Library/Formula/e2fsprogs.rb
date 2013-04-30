require 'formula'

class E2fsprogs < Formula
  homepage 'http://e2fsprogs.sourceforge.net/'
  url 'http://downloads.sourceforge.net/e2fsprogs/e2fsprogs-1.42.7.tar.gz'
  sha1 '897ed5bab4f021834d00ec047ed83766d56ce0a8'

  head 'https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git'

  keg_only "This brew installs several commands which override OS X-provided file system commands."

  depends_on 'pkg-config' => :build
  depends_on 'gettext'

  # MacPorts patch to compile libs correctly.
  # Patch to fix warning about no return value in non-void function.
  def patches; DATA; end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
    system "make install-libs"
  end
end

__END__
--- e2fsprogs-1.42.2/lib/Makefile.darwin-lib.orig	2009-07-01 21:36:13.000000000 -0500
+++ e2fsprogs-1.42.2/lib/Makefile.darwin-lib	2009-08-07 18:47:46.000000000 -0500
@@ -23,7 +23,7 @@
 
 $(BSD_LIB): $(OBJS)
 	$(E) "	GEN_BSD_SOLIB $(BSD_LIB)"
-	$(Q) (cd pic; $(CC) -dynamiclib -compatibility_version 1.0 -current_version $(BSDLIB_VERSION) \
+	$(Q) (cd pic; $(CC) -dynamiclib -install_name $(BSDLIB_INSTALL_DIR)/$(BSD_LIB) -compatibility_version 1.0 -current_version $(BSDLIB_VERSION) -Wl,-single_module \
 		-flat_namespace -undefined warning -o $(BSD_LIB) $(OBJS))
 	$(Q) $(MV) pic/$(BSD_LIB) .
 	$(Q) $(RM) -f ../$(BSD_LIB)

diff -urN e2fsprogs-1.42.7.orig/lib/ext2fs/gen_bitmap64.c e2fsprogs-1.42.7/lib/ext2fs/gen_bitmap64.c
--- e2fsprogs-1.42.7.orig/lib/ext2fs/gen_bitmap64.c	2013-01-21 19:33:35.000000000 -0800
+++ e2fsprogs-1.42.7/lib/ext2fs/gen_bitmap64.c	2013-04-29 23:48:23.000000000 -0700
@@ -657,7 +657,7 @@
 	if ((block < bmap->start) || (block+num-1 > bmap->end)) {
 		ext2fs_warn_bitmap(EXT2_ET_BAD_BLOCK_TEST, block,
 				   bmap->description);
-		return;
+		return EINVAL;
 	}
 
 	return bmap->bitmap_ops->test_clear_bmap_extent(bmap, block, num);

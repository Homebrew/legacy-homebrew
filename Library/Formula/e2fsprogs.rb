require 'formula'

class E2fsprogs < Formula
  homepage 'http://e2fsprogs.sourceforge.net/'
  url 'http://downloads.sourceforge.net/e2fsprogs/e2fsprogs-1.42.8.tar.gz'
  sha1 '79cdb2374a9c0e68f01739598679db06d546b897'

  head 'https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git'

  keg_only "This brew installs several commands which override OS X-provided file system commands."

  depends_on 'pkg-config' => :build
  depends_on 'gettext'

  # MacPorts patch to compile libs correctly.
  # Fix a bare return for clang.
  def patches
    {:p0 => [
      "https://trac.macports.org/export/92117/trunk/dports/sysutils/e2fsprogs/files/patch-lib__Makefile.darwin-lib"
    ], :p1 => DATA}
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
    system "make install-libs"
  end
end

__END__
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

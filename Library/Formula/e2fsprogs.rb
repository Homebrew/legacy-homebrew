require 'formula'

class E2fsprogs < Formula
  url 'http://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.42.2/e2fsprogs-1.42.2.tar.gz'
  homepage 'http://e2fsprogs.sourceforge.net/'
  md5 '04f4561a54ad0419248316a00c016baa'
  head 'https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git', :using => :git

  # Needed to make dylibs actually get installed to prefix. This has been
  # submitted via email to the upstream author.
  def patches
    DATA
  end

  keg_only "This brew installs several commands which override OS X-provided file system commands."

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-bsd-shlibs"
    system "make"
    lib.mkdir
    system "make install"
    system "make install-libs"
  end
end

__END__
diff -urN e2fsprogs-1.41.12.orig/lib/Makefile.darwin-lib e2fsprogs-1.41.12/lib/Makefile.darwin-lib
--- e2fsprogs-1.41.12.orig/lib/Makefile.darwin-lib	2010-05-17 16:07:14.000000000 -0700
+++ e2fsprogs-1.41.12/lib/Makefile.darwin-lib	2011-05-03 16:17:44.000000000 -0700
@@ -23,7 +23,7 @@
 
 $(BSD_LIB): $(OBJS)
 	$(E) "	GEN_BSD_SOLIB $(BSD_LIB)"
-	$(Q) (cd pic; $(CC) -dynamiclib -compatibility_version 1.0 -current_version $(BSDLIB_VERSION) \
+	$(Q) (cd pic; $(CC) -dynamiclib -install_name $(BSDLIB_INSTALL_DIR)/$(BSD_LIB) -compatibility_version 1.0 -current_version $(BSDLIB_VERSION) \
 		-flat_namespace -undefined warning -o $(BSD_LIB) $(OBJS))
 	$(Q) $(MV) pic/$(BSD_LIB) .
 	$(Q) $(RM) -f ../$(BSD_LIB)

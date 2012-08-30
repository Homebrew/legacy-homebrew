require 'formula'

class CrosstoolNg < Formula
  homepage 'http://crosstool-ng.org/'
  url 'http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.16.0.tar.bz2'
  sha1 '087ed58bb8e5557df3b492bc7e9e37c003522a0e'
  
  depends_on 'gnu-sed'
  depends_on 'binutils'
  depends_on 'gawk' 
  depends_on 'automake' 
  depends_on 'coreutils' 

  def install
    system "./configure", "--prefix=#{prefix}",
    "--disable-dependency-tracking", 
    "--with-objcopy=gobjcopy", "--with-objdump=gobjdump",
    "--with-readelf=greadelf", "--with-libtool=glibtool", 
    "--with-libtoolize=glibtoolize", "--with-install=ginstall"
    "CFLAGS=-std=gnu89"
    system "make"
    system "make install"
  end

  def patches
    # Fixes clang offsetof compatability.
    DATA
  end

  def test
    system "false"
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index 3772058..74a2d79 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -348,7 +348,7 @@ KCONFIG_FILES := conf mconf nconf kconfig.mk
 install-lib-kconfig: $(DESTDIR)$(libdir) install-lib-main
 	@echo "  INST    'kconfig/'"
 	@for f in $(KCONFIG_FILES); do                                      \
-	    install -D "kconfig/$${f}" "$(DESTDIR)$(libdir)/kconfig/$${f}"; \
+	    $(install) -D "kconfig/$${f}" "$(DESTDIR)$(libdir)/kconfig/$${f}"; \
 	 done
 
 install-doc: $(DESTDIR)$(docdir)
diff --git a/kconfig/zconf.gperf b/kconfig/zconf.gperf
index c9e690e..760b01b 100644
--- a/kconfig/zconf.gperf
+++ b/kconfig/zconf.gperf
@@ -6,6 +6,9 @@
 %enum
 %pic
 %struct-type
+%{
+#include <stddef.h>
+%}
 
 struct kconf_id;


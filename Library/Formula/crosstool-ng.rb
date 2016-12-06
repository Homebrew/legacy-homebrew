require 'formula'

class CrosstoolNg < Formula
  homepage 'http://crosstool-ng.org'
  url 'http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.16.0.tar.bz2'
  sha1 '087ed58bb8e5557df3b492bc7e9e37c003522a0e'

  depends_on 'wget'
  depends_on 'gnu-sed'
  depends_on 'gawk'
  depends_on 'binutils'
  depends_on 'automake' => :build
  depends_on 'coreutils' => :build

  # Fixes clang offsetof compatability.  Took better patch from #14547
  def patches; DATA; end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--exec-prefix=#{prefix}",
                          "--with-objcopy=gobjcopy",
                          "--with-objdump=gobjdump",
                          "--with-readelf=greadelf",
                          "--with-libtool=glibtool",
                          "--with-libtoolize=glibtoolize",
                          "--with-install=ginstall",
                          "CFLAGS=-std=gnu89"
    system "make install"
  end

  def test
    system "#{bin}/ct-ng version"
  end

  def caveats; <<-EOS.undent
    If building a cross compiler your may expirience the following error:
      error: elf.h: No such file or directory
    To fix it, perform the following:
      curl https://raw.github.com/gist/3769372/98e0a084470d2d6be7b4b61551ef00d44c682b4a/elf.h > elf.h
      sudo cp -p elf.h /usr/local/include/
  EOS
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

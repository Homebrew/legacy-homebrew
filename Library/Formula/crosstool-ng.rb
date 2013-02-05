require 'formula'

class CrosstoolNg < Formula
  homepage 'http://crosstool-ng.org'
  url 'http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.18.0.tar.bz2'
  sha1 'ea9aa0521683486efb02596d9dfe00f66e18fdc3'

  depends_on :automake
  depends_on 'coreutils' => :build
  depends_on 'wget'
  depends_on 'gnu-sed'
  depends_on 'gawk'
  depends_on 'binutils'

  env :std

  def patches
    # Fixes clang offsetof compatability. Took better patch from #14547
    DATA
  end

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
    # Must be done in two steps
    system "make"
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
      cp -p elf.h /usr/local/include/
    EOS
  end
end

__END__
diff --git a/kconfig/zconf.gperf b/kconfig/zconf.gperf
index c9e690e..21e79e4 100644
--- a/kconfig/zconf.gperf
+++ b/kconfig/zconf.gperf
@@ -7,6 +7,10 @@
 %pic
 %struct-type

+%{
+#include <stddef.h>
+%}
+
 struct kconf_id;

 static struct kconf_id *kconf_id_lookup(register const char *str, register unsigned int len);

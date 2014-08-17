require 'formula'

class CrosstoolNg < Formula
  homepage 'http://crosstool-ng.org'
  url 'http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.19.0.tar.bz2'
  sha1 'b7ae3e90756b499ff5362064b7d80f8a45d09bfb'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on 'coreutils' => :build
  depends_on 'wget'
  depends_on 'gnu-sed'
  depends_on 'gawk'
  depends_on 'binutils'
  depends_on 'libelf'

  # Avoid superenv to prevent https://github.com/mxcl/homebrew/pull/10552#issuecomment-9736248
  env :std

  # Fixes clang offsetof compatability. Took better patch from #14547
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--exec-prefix=#{prefix}",
                          "--with-objcopy=gobjcopy",
                          "--with-objdump=gobjdump",
                          "--with-readelf=greadelf",
                          "--with-libtool=glibtool",
                          "--with-libtoolize=glibtoolize",
                          "--with-install=ginstall",
                          "--with-sed=gsed",
                          "--with-awk=gawk",
                          "CFLAGS=-std=gnu89"
    # Must be done in two steps
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    You will need to install modern gcc compiler in order to use this tool.
    EOS
  end

  test do
    system "#{bin}/ct-ng", "version"
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

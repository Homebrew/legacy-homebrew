require 'formula'

class CrosstoolNg < Formula
  homepage 'http://crosstool-ng.org'
  url 'http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.17.0.tar.bz2'
  sha1 '39a8d075bb8106fbc25e537a147228253dbf8cb7'

  depends_on :automake => :build
  depends_on 'coreutils' => :build
  depends_on 'wget'
  depends_on 'gnu-sed'
  depends_on 'gawk'
  depends_on 'binutils'

  env :std

  def patches
    # Fixes clang offsetof compatability. Took better patch from #14547
    p = [DATA]
    # The following patches are already upstream.
    # They can be removed at the next release.
    p << 'http://crosstool-ng.org/download/crosstool-ng/01-fixes/1.17.0/000-scripts_unquoted_variable_reference_in_glibc_eglibc_sh_common.patch'
    p << 'http://crosstool-ng.org/download/crosstool-ng/01-fixes/1.17.0/001-scripts_fail_on_in_paths.patch'
    # The 'case ;;&' construct is a bash4ism. Get rid of it.
    p << 'http://crosstool-ng.org/download/crosstool-ng/01-fixes/1.17.0/002-scripts_functions_fix_debug_shell.patch'
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

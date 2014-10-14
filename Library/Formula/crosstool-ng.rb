require 'formula'

class CrosstoolNg < Formula
  homepage 'http://crosstool-ng.org'
  url 'http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.20.0.tar.bz2'
  sha1 'b11f7ee706753b8cf822f98b549f8ab9dd8da9c7'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on 'coreutils' => :build
  depends_on 'wget'
  depends_on 'gnu-sed'
  depends_on 'gawk'
  depends_on 'binutils'
  depends_on 'libelf'
  option "with-grep", "Compile with GNU grep from dupes"
  depends_on 'homebrew/dupes/grep' => :optional
  option "with-make", "Compile with GNU make from dupes"
  depends_on 'homebrew/dupes/make' => :optional

  # Avoid superenv to prevent https://github.com/mxcl/homebrew/pull/10552#issuecomment-9736248
  env :std

  # Fixes clang offsetof compatability. Took better patch from #14547
  # Patch scripts/crosstool-NG.sh.in to use regex compatible with BSD grep.
  # Can be removed if committed upstream http://patchwork.ozlabs.org/patch/399382/
  patch :DATA

  def install
    args = ["--prefix=#{prefix}",
            "--exec-prefix=#{prefix}",
            "--with-objcopy=gobjcopy",
            "--with-objdump=gobjdump",
            "--with-readelf=greadelf",
            "--with-libtool=glibtool",
            "--with-libtoolize=glibtoolize",
            "--with-install=ginstall",
            "--with-sed=gsed",
            "--with-awk=gawk"]

    args << "--with-grep=ggrep" if build.with? "grep"

    args << "--with-make=gmake" if build.with? "make"

    args << "CFLAGS=-std=gnu89"

    system "./configure", *args

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

diff --git a/scripts/crosstool-NG.sh.in b/scripts/crosstool-NG.sh.in
index cd65d5b..53ac552 100644
--- a/scripts/crosstool-NG.sh.in
+++ b/scripts/crosstool-NG.sh.in
@@ -125,7 +125,7 @@ CT_DoLog INFO "Build started ${CT_STAR_DATE_HUMAN}"
 # We really need to extract from ,config and not .config.2, as we
 # do want the kconfig's values, not our mangled config with arrays.
 CT_DoStep DEBUG "Dumping user-supplied crosstool-NG configuration"
-CT_DoExecLog DEBUG ${grep} -E '^(# |)CT_' .config
+CT_DoExecLog DEBUG ${grep} -E '^(# )?CT_' .config
 CT_EndStep
 
 CT_DoLog DEBUG "Unsetting and unexporting MAKEFLAGS"

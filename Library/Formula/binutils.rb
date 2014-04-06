require 'formula'

class Binutils < Formula
  homepage 'http://www.gnu.org/software/binutils/binutils.html'
  url 'http://ftpmirror.gnu.org/binutils/binutils-2.24.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/binutils/binutils-2.24.tar.gz'
  sha1 '1b2bc33003f4997d38fadaa276c1f0321329ec56'

  option "with-libiberty", "Also install libiberty."

  # Fixes PR56780 which prevents libiberty from being installed.
  #  * https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;a=commit;h=369be6981b26787b2685e3b8c6da779dae8ce35f
  #    The original patch cannot be cleanly applied to binutils 2.24 due to
  #    differences in libiberty/ChangeLog.
  patch :DATA if build.with? "libiberty"

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--program-prefix=g",
            "--prefix=#{prefix}",
            "--infodir=#{info}",
            "--mandir=#{man}",
            "--disable-werror",
            "--enable-interwork",
            "--enable-multilib",
            "--enable-64-bit-bfd",
            "--enable-targets=all"]
    args << "--enable-install-libiberty" if build.with? "libiberty"

    system "./configure", *args
    system "make"
    system "make install"
  end
end

__END__
diff --git a/libiberty/configure b/libiberty/configure
index 8ea54da..7bde9b3 100755
--- a/libiberty/configure
+++ b/libiberty/configure
@@ -5510,7 +5510,6 @@ fi

 setobjs=
 CHECK=
-target_header_dir=
 if test -n "${with_target_subdir}"; then

   # We are being configured as a target library.  AC_REPLACE_FUNCS

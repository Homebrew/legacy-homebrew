require 'formula'

class Binutils < Formula
  homepage 'http://www.gnu.org/software/binutils/binutils.html'
  url 'http://ftpmirror.gnu.org/binutils/binutils-2.24.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/binutils/binutils-2.24.tar.gz'
  sha1 '1b2bc33003f4997d38fadaa276c1f0321329ec56'
  revision 1

  # [PATCH] binutils: fix --enable-install-libiberty flag
  # fixed the --disable-install-libiberty behavior, but it also
  # added a bug where the enable path never works because the initial clear
  # of target_header_dir wasn't deleted.  So we end up initializing properly
  # at the top only to reset it at the end all the time.
  #  http://gcc.gnu.org/ml/gcc-patches/2014-01/msg00213.html
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--program-prefix=g",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--disable-werror",
                          "--enable-interwork",
                          "--enable-multilib",
                          "--enable-64-bit-bfd",
                          "--enable-install-libiberty",
                          "--enable-targets=all"
    system "make"
    system "make install"
  end
end

__END__
diff --git a/libiberty/configure b/libiberty/configure
index e601ccd..878fa53 100755
--- a/libiberty/configure
+++ b/libiberty/configure
@@ -5507,7 +5507,6 @@ fi
 
 setobjs=
 CHECK=
-target_header_dir=
 if test -n "${with_target_subdir}"; then
 
   # We are being configured as a target library.  AC_REPLACE_FUNCS
diff --git a/libiberty/configure.ac b/libiberty/configure.ac
index fcea46f..f17e6b6 100644
--- a/libiberty/configure.ac
+++ b/libiberty/configure.ac
@@ -405,7 +405,6 @@ fi
 
 setobjs=
 CHECK=
-target_header_dir=
 if test -n "${with_target_subdir}"; then
 
   # We are being configured as a target library.  AC_REPLACE_FUNCS

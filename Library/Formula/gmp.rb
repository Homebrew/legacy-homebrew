require 'formula'

class Gmp < Formula
  url 'http://ftpmirror.gnu.org/gmp/gmp-5.0.2.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/gmp/gmp-5.0.2.tar.bz2'
  homepage 'http://gmplib.org/'
  sha1 '2968220e1988eabb61f921d11e5d2db5431e0a35'

  def options
    [
      ["--32-bit", "Force 32-bit."],
      ["--skip-check", "Do not run 'make check' to verify libraries."]
    ]
  end

  # Fixes make check for xcode 4.2. See:
  # http://gmplib.org/list-archives/gmp-bugs/2011-July/002308.html
  def patches
    DATA if MacOS.xcode_version >= "4.2"
  end

  def install
    # Reports of problems using gcc 4.0 on Leopard
    # https://github.com/mxcl/homebrew/issues/issue/2302
    # Also force use of 4.2 on 10.6 in case a user has changed the default
    # Do not force if xcode > 4.2 since it does not have /usr/bin/gcc-4.2 as default
    unless MacOS.xcode_version >= "4.2"
      ENV.gcc_4_2
    end

    args = ["--prefix=#{prefix}", "--enable-cxx"]

    # Build 32-bit where appropriate, and help configure find 64-bit CPUs
    # see: http://gmplib.org/macos.html
    if MacOS.prefer_64_bit? and not ARGV.include? "--32-bit"
      ENV.m64
      args << "--build=x86_64-apple-darwin"
    else
      ENV.m32
      args << "--build=none-apple-darwin"
    end

    system "./configure", *args
    system "make"
    ENV.j1 # Doesn't install in parallel on 8-core Mac Pro
    system "make install"

    # Different compilers and options can cause tests to fail even
    # if everything compiles, so yes, we want to do this step.
    system "make check" unless ARGV.include? "--skip-check"
  end
end

__END__
diff --git a/acinclude.m4 b/acinclude.m4
index 699dd7b..87b5f6f 100644
--- a/acinclude.m4
+++ b/acinclude.m4
@@ -1941,8 +1941,8 @@ X86_PATTERN | x86_64-*-*)
 esac
 
 cat >conftest.c <<EOF
-extern const int foo[];		/* Suppresses C++'s suppression of foo */
-const int foo[] = {1,2,3};
+extern const int foo[[]];		/* Suppresses C++'s suppression of foo */
+const int foo[[]] = {1,2,3};
 EOF
 echo "Test program:" >&AC_FD_CC
 cat conftest.c >&AC_FD_CC
diff --git a/configure b/configure
index 07b9fda..f6df8cd 100755
--- a/configure
+++ b/configure
@@ -26446,8 +26446,8 @@ i?86*-*-* | k[5-8]*-*-* | pentium*-*-* | athlon-*-* | viac3*-*-* | geode*-*-* |
 esac
 
 cat >conftest.c <<EOF
-extern const int foo;		/* Suppresses C++'s suppression of foo */
-const int foo = {1,2,3};
+extern const int foo[];		/* Suppresses C++'s suppression of foo */
+const int foo[] = {1,2,3};
 EOF
 echo "Test program:" >&5
 cat conftest.c >&5

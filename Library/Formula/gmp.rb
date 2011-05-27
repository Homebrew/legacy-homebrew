require 'formula'

class Gmp < Formula
  url 'ftp://ftp.gnu.org/gnu/gmp/gmp-5.0.1.tar.bz2'
  homepage 'http://gmplib.org/'
  sha1 '6340edc7ceb95f9015a758c7c0d196eb0f441d49'

  def options
    [
      ["--32-bit", "Force 32-bit."],
      ["--skip-check", "Do not run 'make check' to verify libraries."]
    ]
  end

  fails_with_llvm "Tests fail to compile; missing references in 'llvm bitcode in libtests.a(misc.o)'."

  def install
    # Reports of problems using gcc 4.0 on Leopard
    # https://github.com/mxcl/homebrew/issues/issue/2302
    # Also force use of 4.2 on 10.6 in case a user has changed the default
    ENV.gcc_4_2

    args = ["--prefix=#{prefix}", "--infodir=#{info}", "--enable-cxx"]

    # Build 32-bit where appropriate, and help configure find 64-bit CPUs
    if MacOS.prefer_64_bit? and not ARGV.include? "--32-bit"
      ENV.m64
      args << "--build=x86_64-apple-darwin"
    else
      ENV.m32
      args << "--host=none-apple-darwin"
    end

    system "./configure", *args
    system "make"
    ENV.j1 # Don't install in parallel
    system "make install"

    # Different compilers and options can cause tests to fail even
    # if everything compiles, so yes, we want to do this step.
    system "make check" unless ARGV.include? "--skip-check"
  end
end

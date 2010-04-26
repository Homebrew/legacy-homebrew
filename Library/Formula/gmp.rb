require 'formula'

class Gmp <Formula
  url 'ftp://ftp.gnu.org/gnu/gmp/gmp-5.0.1.tar.bz2'
  homepage 'http://gmplib.org/'
  sha1 '6340edc7ceb95f9015a758c7c0d196eb0f441d49'

  def options
    [
      ["--skip-check", "Do not run 'make check' to verify libraries. (Not recommended.)"],
      ["--32-bit", "Force 32-bit on Leopard on 64-bit machines."]
    ]
  end

  def install
    # On OS X 10.6, some tests fail under LLVM
    ENV.gcc_4_2

    args = ["--prefix=#{prefix}", "--infodir=#{info}", "--enable-cxx"]

    if MACOS_VERSION == 10.5
      if Hardware.is_32_bit? or ARGV.include? "--32-bit"
        ENV.m32
        args << "--host=none-apple-darwin"
      else
        ENV.m64
      end
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

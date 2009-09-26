require 'brewkit'

class Gmp <Formula
  url 'ftp://ftp.gnu.org/gnu/gmp/gmp-4.3.1.tar.bz2'
  homepage 'http://gmplib.org/'
  sha1 'acbd1edc61230b1457e9742136994110e4f381b2'

  def install
    if MACOS_VERSION == 10.6
      # On OS X 10.6, some tests fail under LLVM
      ENV.gcc_4_2
    end

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
    
    # Verify that the library compiled correctly.
    system "make check"
  end
end

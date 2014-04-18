require 'formula'

class Gmp < Formula
  homepage 'http://gmplib.org/'
  url 'ftp://ftp.gmplib.org/pub/gmp/gmp-6.0.0a.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/gmp/gmp-6.0.0a.tar.bz2'
  sha1 '360802e3541a3da08ab4b55268c80f799939fddc'

  bottle do
    cellar :any
    revision 2
    sha1 '8390518974834c6a9e959e3a9d6e5eba91152eec' => :mavericks
    sha1 'b042ffe0c394dafab04f23ce03dc2cb691dc2a87' => :mountain_lion
    sha1 'a767aafc398054b6eb413b7dd70c7c9721d84734' => :lion
  end

  option '32-bit'
  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    args = ["--prefix=#{prefix}", "--enable-cxx"]

    if build.build_32_bit?
      ENV.m32
      ENV.append 'ABI', '32'
      # https://github.com/Homebrew/homebrew/issues/20693
      args << "--disable-assembly"
    elsif build.bottle?
      args << "--disable-assembly"
    end

    system "./configure", *args
    system "make"
    system "make check"
    ENV.deparallelize
    system "make install"
  end
end

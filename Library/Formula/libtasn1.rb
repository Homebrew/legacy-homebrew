require "formula"

class Libtasn1 < Formula
  homepage "https://www.gnu.org/software/libtasn1/"
  url "http://ftpmirror.gnu.org/libtasn1/libtasn1-3.6.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libtasn1/libtasn1-3.6.tar.gz"
  sha1 "0b0ac4388ee08f90b90dccfec63e5b026f23cf2c"

  bottle do
    cellar :any
    sha1 "3483f10166453c12db565758595ee5bb39dfe563" => :mavericks
    sha1 "85c4ec48dad24eca7417d61665579451d7b068ac" => :mountain_lion
    sha1 "1db5e62f67e941a610b9a42e93662a78989a454d" => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end

require "formula"

class Libtasn1 < Formula
  homepage "https://www.gnu.org/software/libtasn1/"
  url "http://ftpmirror.gnu.org/libtasn1/libtasn1-3.6.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libtasn1/libtasn1-3.6.tar.gz"
  sha1 "0b0ac4388ee08f90b90dccfec63e5b026f23cf2c"

  bottle do
    cellar :any
    sha1 "a869428872e2199e8dd65dbddf1fcfe85623480f" => :mavericks
    sha1 "7563ceb8d9607476b56e9bc76702dac3ae5a1f53" => :mountain_lion
    sha1 "ed91e13556c66df19e55846c2f8d6d75f8fb5c44" => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end

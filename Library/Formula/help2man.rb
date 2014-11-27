require "formula"

class Help2man < Formula
  homepage "http://www.gnu.org/software/help2man/"
  url "http://ftpmirror.gnu.org/help2man/help2man-1.46.4.tar.xz"
  mirror "http://ftp.gnu.org/gnu/help2man/help2man-1.46.4.tar.xz"
  sha256 "1ae7f15f53b0cc55b070ae49df2ee5caa942c71529054e157599427bba3c5633"

  bottle do
    cellar :any
    sha1 "6ba98c8f097531912e58863dee1247cb02f9c289" => :yosemite
    sha1 "747eadb45bf3bbcd2e2fd58dac062495768dd912" => :mavericks
    sha1 "134e606290c5c93f915c51fbe87a6ddaa352f1fd" => :mountain_lion
  end

  def install
    # install is not parallel safe
    # see https://github.com/Homebrew/homebrew/issues/12609
    ENV.j1

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

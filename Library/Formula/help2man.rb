require "formula"

class Help2man < Formula
  homepage "http://www.gnu.org/software/help2man/"
  url "http://ftpmirror.gnu.org/help2man/help2man-1.46.3.tar.xz"
  mirror "http://ftp.gnu.org/gnu/help2man/help2man-1.46.3.tar.xz"
  sha256 "a669dc3baf2f9fcfcf9d55d8555d1c234bc3cabd5fbe8e36e0dea4a88c222942"

  bottle do
    cellar :any
    revision 1
    sha1 "778ffe703ac221770ab2794b546e58b82a41821e" => :yosemite
    sha1 "820ffc71397b627d1ac6d0c9e4ac6993af2c6203" => :mavericks
    sha1 "a2d53fcffac92dcc7dc7d89ac799c131f2de510d" => :mountain_lion
  end

  def install
    # install is not parallel safe
    # see https://github.com/Homebrew/homebrew/issues/12609
    ENV.j1

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

require "formula"

class Help2man < Formula
  homepage "http://www.gnu.org/software/help2man/"
  url "http://ftpmirror.gnu.org/help2man/help2man-1.46.4.tar.xz"
  mirror "http://ftp.gnu.org/gnu/help2man/help2man-1.46.4.tar.xz"
  sha256 "1ae7f15f53b0cc55b070ae49df2ee5caa942c71529054e157599427bba3c5633"

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

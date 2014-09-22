require "formula"

class Help2man < Formula
  homepage "http://www.gnu.org/software/help2man/"
  url "http://ftpmirror.gnu.org/help2man/help2man-1.46.2.tar.xz"
  mirror "http://ftp.gnu.org/gnu/help2man/help2man-1.46.2.tar.xz"
  sha256 "92191decc8c324c88bfec5e989d13108f22ed135d794bde2b3b802ffe3650311"

  bottle do
    cellar :any
    sha1 "2f432d716f8225e6b698078c65fd44a0588cee74" => :mavericks
    sha1 "8d2228346994f1f004898126144ea4a4466f9316" => :mountain_lion
    sha1 "4d903506ba1f27bd570ec3cd4012dcfb3cb569df" => :lion
  end

  def install
    # install is not parallel safe
    # see https://github.com/Homebrew/homebrew/issues/12609
    ENV.j1

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

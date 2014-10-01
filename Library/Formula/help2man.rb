require "formula"

class Help2man < Formula
  homepage "http://www.gnu.org/software/help2man/"
  url "http://ftpmirror.gnu.org/help2man/help2man-1.46.3.tar.xz"
  mirror "http://ftp.gnu.org/gnu/help2man/help2man-1.46.3.tar.xz"
  sha256 "a669dc3baf2f9fcfcf9d55d8555d1c234bc3cabd5fbe8e36e0dea4a88c222942"

  bottle do
  end

  def install
    # install is not parallel safe
    # see https://github.com/Homebrew/homebrew/issues/12609
    ENV.j1

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

require "formula"

class Help2man < Formula
  homepage "http://www.gnu.org/software/help2man/"
  url "http://ftpmirror.gnu.org/help2man/help2man-1.46.1.tar.xz"
  mirror "http://ftp.gnu.org/gnu/help2man/help2man-1.46.1.tar.xz"
  sha256 "3dfd02a026149aad06887c1cb6062471779c100e00aecb79b8f9d01cf1581c47"

  bottle do
    cellar :any
    sha1 "8ee54313de90e7362ac98f5b93adaad3de1986e6" => :mavericks
    sha1 "8de37051ce5504b73ebe067cc38ec0063f6f9540" => :mountain_lion
    sha1 "26c6736453c30840a662fffe55172cfbe300e4ef" => :lion
  end

  def install
    # install is not parallel safe
    # see https://github.com/Homebrew/homebrew/issues/12609
    ENV.j1

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

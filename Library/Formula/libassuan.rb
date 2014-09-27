require "formula"

class Libassuan < Formula
  homepage "http://www.gnupg.org/related_software/libassuan/index.en.html"
  url "ftp://ftp.gnupg.org/gcrypt/libassuan/libassuan-2.1.2.tar.bz2"
  mirror "ftp://mirror.tje.me.uk/pub/mirrors/ftp.gnupg.org/libassuan/libassuan-2.1.2.tar.bz2"
  sha1 "7aed69734ba64b63004107cada671b5861d332a4"

  bottle do
    cellar :any
    sha1 "9ebb48d3bf64d7f9ca30940008488e7d76802236" => :mavericks
    sha1 "f16850ab6cfd53096c21cd6f9d0da39210ded0dc" => :mountain_lion
    sha1 "0369b0ef7e54a8845aff4f16470e39c814341d01" => :lion
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

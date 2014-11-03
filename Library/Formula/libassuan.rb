require "formula"

class Libassuan < Formula
  homepage "http://www.gnupg.org/related_software/libassuan/index.en.html"
  url "ftp://ftp.gnupg.org/gcrypt/libassuan/libassuan-2.1.2.tar.bz2"
  mirror "ftp://mirror.tje.me.uk/pub/mirrors/ftp.gnupg.org/libassuan/libassuan-2.1.2.tar.bz2"
  sha1 "7aed69734ba64b63004107cada671b5861d332a4"

  bottle do
    cellar :any
    revision 1
    sha1 "b096e4c29bbe9f706386e1f5fb0b6aeae79804a4" => :yosemite
    sha1 "5e2dc4817c5947892920025a9cf937f51480a5f4" => :mavericks
    sha1 "15f6f77e99f1f3b8f9a52e2703ff5d2ae1f05101" => :mountain_lion
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

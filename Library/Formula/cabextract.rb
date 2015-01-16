require "formula"

class Cabextract < Formula
  homepage "http://www.cabextract.org.uk/"
  url "http://www.cabextract.org.uk/cabextract-1.4.tar.gz"
  sha1 "b1d5dd668d2dbe95b47aad6e92c0b7183ced70f1"

  bottle do
    cellar :any
    sha1 "7bb2b3a1ed06161c81d23fd8735477317bad86d7" => :yosemite
    sha1 "b81507d68f43f9c32f5614293247eab43a61177c" => :mavericks
    sha1 "8c9696a300165c215e741d644502a5ea22a65173" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

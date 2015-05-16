require 'formula'

class Libao < Formula
  homepage 'http://www.xiph.org/ao/'
  url 'http://downloads.xiph.org/releases/ao/libao-1.2.0.tar.gz'
  sha1 '6b1d2c6a2e388e3bb6ebea158d51afef18aacc56'

  bottle do
    revision 1
    sha1 "9654b94ab07fed570d4b1ea71473a9f9f8020e43" => :yosemite
    sha1 "7a897f67a80378e5b4c838c7a45d03acc1f9b391" => :mavericks
    sha1 "f6fac2951b26b0df3a91da55ad5763e23183eace" => :mountain_lion
  end

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make install"
  end
end

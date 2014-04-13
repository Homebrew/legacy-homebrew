require 'formula'

class Nettle < Formula
  homepage 'http://www.lysator.liu.se/~nisse/nettle/'
  url 'http://www.lysator.liu.se/~nisse/archive/nettle-2.7.1.tar.gz'
  sha1 'e7477df5f66e650c4c4738ec8e01c2efdb5d1211'

  bottle do
    cellar :any
    revision 1
    sha1 "89238f83e4f3f18145553d3c442fe022680cbd7b" => :mavericks
    sha1 "8f2a4c261926f2f62e9d8f197a8466a2489b37e0" => :mountain_lion
    sha1 "6c56084887da5b7e99d7c730bf22a68c9af360e9" => :lion
  end

  depends_on 'gmp'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make install"
    system "make check"
  end
end

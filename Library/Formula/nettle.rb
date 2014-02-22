require 'formula'

class Nettle < Formula
  homepage 'http://www.lysator.liu.se/~nisse/nettle/'
  url 'http://www.lysator.liu.se/~nisse/archive/nettle-2.6.tar.gz'
  sha1 '401f982a0b365e04c8c38c4da42afdd7d2d51d80'

  bottle do
    cellar :any
    sha1 "7e05202e46a27cd917080b8cabcfa2f97abebab3" => :mavericks
    sha1 "da54d410d113c5bbce67d021b0a65cd52ee0cd36" => :mountain_lion
    sha1 "ae174af411ee2ecc8269ce32f4c64e45871f1f42" => :lion
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

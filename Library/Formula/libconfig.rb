require 'formula'

class Libconfig < Formula
  url 'http://www.hyperrealm.com/libconfig/libconfig-1.4.7.tar.gz'
  homepage 'http://www.hyperrealm.com/libconfig/'
  md5 'd57da7a91aadbfd53afedb5c1bade5f4'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

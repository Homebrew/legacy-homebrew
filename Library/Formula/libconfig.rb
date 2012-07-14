require 'formula'

class Libconfig < Formula
  homepage 'http://www.hyperrealm.com/libconfig/'
  url 'http://www.hyperrealm.com/libconfig/libconfig-1.4.8.tar.gz'
  sha1 'c16b9caa207afdf36fc664ad0b2807ecc7a562fa'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

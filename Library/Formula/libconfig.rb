require 'formula'

class Libconfig < Formula
  url 'http://www.hyperrealm.com/libconfig/libconfig-1.4.5.tar.gz'
  homepage 'http://www.hyperrealm.com/libconfig/'
  md5 'f2219e1b2501e7296a7d3e971c63666a'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

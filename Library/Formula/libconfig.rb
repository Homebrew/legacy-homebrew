require 'formula'

class Libconfig < Formula
  homepage 'http://www.hyperrealm.com/libconfig/'
  url 'http://www.hyperrealm.com/libconfig/libconfig-1.4.9.tar.gz'
  sha1 'b7a3c307dfb388e57d9a35c7f13f6232116930ec'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

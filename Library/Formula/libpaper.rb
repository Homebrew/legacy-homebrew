require 'formula'

class Libpaper < Formula
  url 'http://ftp.de.debian.org/debian/pool/main/libp/libpaper/libpaper_1.1.24+nmu1.tar.gz'
  homepage 'http://packages.debian.org/unstable/source/libpaper'
  md5 '30d9c62b5757072fa90aee6f46ba2c39'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

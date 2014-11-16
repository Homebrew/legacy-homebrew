require 'formula'

class Mdf2iso < Formula
  homepage 'http://mdf2iso.berlios.de/'
  url 'http://ftp.de.debian.org/debian/pool/main/m/mdf2iso/mdf2iso_0.3.0.orig.tar.gz'
  sha1 '949d4fa0bb1e40ca17842a265d8ed813bac4917a'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

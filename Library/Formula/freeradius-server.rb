require 'formula'

class FreeradiusServer < Formula
  url 'ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-2.1.12.tar.gz'
  homepage 'http://freeradius.org/'
  md5 'dcbaed16df8ccff672ba132a08bf8510'

  skip_clean :all

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

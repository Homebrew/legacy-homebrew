require 'formula'

class FreeradiusServer < Formula
  url 'ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-2.1.11.tar.gz'
  homepage 'http://freeradius.org/'
  md5 '49904610a77d978395532b5647c7e141'

  skip_clean :all

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

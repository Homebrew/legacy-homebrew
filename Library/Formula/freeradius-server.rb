require 'formula'

class FreeradiusServer < Formula
  url 'ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-2.1.10.tar.gz'
  homepage 'http://freeradius.org/'
  md5 'e552704fc1b46d51176e575afa96dcc6'

  skip_clean :all

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

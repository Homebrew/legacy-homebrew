require 'formula'

class FreeradiusServer < Formula
  url 'ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-2.1.12.tar.gz'
  homepage 'http://freeradius.org/'
  sha1 '22b5d9e59369b8a3caa3c778871bf579ae7a8a9c'

  skip_clean :all

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

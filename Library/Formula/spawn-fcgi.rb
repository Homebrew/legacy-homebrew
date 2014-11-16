require 'formula'

class SpawnFcgi < Formula
  homepage 'http://redmine.lighttpd.net/projects/spawn-fcgi'
  url 'http://www.lighttpd.net/download/spawn-fcgi-1.6.4.tar.gz'
  sha1 '0b10126be40431b00591a28f155efdb77a460161'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

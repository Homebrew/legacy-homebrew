require 'formula'

class SpawnFcgi < Formula
  homepage 'http://redmine.lighttpd.net/projects/spawn-fcgi'
  url 'http://www.lighttpd.net/download/spawn-fcgi-1.6.3.tar.gz'
  sha1 '2b97ea57d9d79745fe8d6051d830fa507b421169'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

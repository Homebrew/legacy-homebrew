require 'formula'

class SpawnFcgi <Formula
  url 'http://www.lighttpd.net/download/spawn-fcgi-1.6.3.tar.gz'
  homepage 'http://redmine.lighttpd.net/projects/spawn-fcgi'
  md5 '6d75f9e9435056fa1e574d836d823cd0'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

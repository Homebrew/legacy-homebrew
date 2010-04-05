require 'formula'

class Privoxy <Formula
  url 'http://downloads.sourceforge.net/project/ijbswa/Sources/3.0.16%20%28stable%29/privoxy-3.0.16-stable-src.tar.gz'
  homepage 'http://www.privoxy.org'
  version '3.0.16'
  md5 '64d3ffcdf8307e04a375773bb4eb255e'

  def install
    system "autoreconf -i"
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

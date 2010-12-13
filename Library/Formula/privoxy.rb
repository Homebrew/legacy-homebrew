require 'formula'

class Privoxy <Formula
  url 'http://downloads.sourceforge.net/project/ijbswa/Sources/3.0.17%20%28stable%29/privoxy-3.0.17-stable-src.tar.gz'
  homepage 'http://www.privoxy.org'
  version '3.0.17'
  md5 '9d363d738a3f3d73e774d6dfeafdb15f'

  def install
    system "autoreconf -i"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/privoxy"
    system "make"
    system "make install"
  end
end

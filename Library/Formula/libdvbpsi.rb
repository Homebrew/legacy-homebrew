require 'formula'

class Libdvbpsi <Formula
  url 'http://download.videolan.org/pub/libdvbpsi/0.1.6/libdvbpsi5-0.1.6.tar.bz2'
  md5 'bd2d9861be3311e1e03c91cd9345f542'
  homepage 'http://www.videolan.org/developers/libdvbpsi.html'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--enable-release"
    system "make install"
  end
end

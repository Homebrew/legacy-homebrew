require 'formula'

class Libdvbpsi < Formula
  url 'http://download.videolan.org/pub/libdvbpsi/0.1.7/libdvbpsi-0.1.7.tar.bz2'
  md5 'af419575719e356b908b0c6946499052'
  homepage 'http://www.videolan.org/developers/libdvbpsi.html'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--enable-release"
    system "make install"
  end
end

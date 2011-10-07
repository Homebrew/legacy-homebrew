require 'formula'

class Libwmf < Formula
  url 'http://downloads.sourceforge.net/project/wvware/libwmf/0.2.8.4/libwmf-0.2.8.4.tar.gz'
  homepage 'http://wvware.sourceforge.net/libwmf.html'
  md5 'd1177739bf1ceb07f57421f0cee191e0'

  depends_on 'pkg-config' => :build
  depends_on 'gd'

  def install
    ENV.libpng
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-freetype=/usr/X11"
    system "make"
    ENV.j1 # yet another rubbish Makefile
    system "make install"
  end
end

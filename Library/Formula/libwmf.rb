require 'formula'

class Libwmf < Formula
  url 'http://downloads.sourceforge.net/project/wvware/libwmf/0.2.8.4/libwmf-0.2.8.4.tar.gz'
  homepage 'http://wvware.sourceforge.net/libwmf.html'
  sha1 '822ab3bd0f5e8f39ad732f2774a8e9f18fc91e89'

  depends_on 'pkg-config' => :build
  depends_on 'gd'
  depends_on :libpng

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-freetype=#{MacOS::X11.prefix}"
    system "make"
    ENV.j1 # yet another rubbish Makefile
    system "make install"
  end
end

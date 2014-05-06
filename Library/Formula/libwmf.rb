require 'formula'

class Libwmf < Formula
  homepage 'http://wvware.sourceforge.net/libwmf.html'
  url 'https://downloads.sourceforge.net/project/wvware/libwmf/0.2.8.4/libwmf-0.2.8.4.tar.gz'
  sha1 '822ab3bd0f5e8f39ad732f2774a8e9f18fc91e89'
  revision 1

  depends_on 'pkg-config' => :build
  depends_on 'gd'
  depends_on 'freetype'
  depends_on 'libpng'
  depends_on 'jpeg'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-png=#{Formula["libpng"].opt_prefix}",
                          "--with-freetype=#{Formula["freetype"].opt_prefix}"
    system "make"
    ENV.j1 # yet another rubbish Makefile
    system "make install"
  end
end

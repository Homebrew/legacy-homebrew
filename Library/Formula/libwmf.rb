require 'formula'

class Libwmf < Formula
  homepage 'http://wvware.sourceforge.net/libwmf.html'
  url 'http://downloads.sourceforge.net/project/wvware/libwmf/0.2.8.4/libwmf-0.2.8.4.tar.gz'
  sha1 '822ab3bd0f5e8f39ad732f2774a8e9f18fc91e89'

  depends_on 'pkg-config' => :build
  depends_on 'gd'
  depends_on :freetype
  depends_on :libpng

  def install
    dep_prefix = (MacOS.version >= :mountain_lion) ? HOMEBREW_PREFIX : MacOS::X11.prefix

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-png=#{dep_prefix}",
                          "--with-freetype=#{dep_prefix}"
    system "make"
    ENV.j1 # yet another rubbish Makefile
    system "make install"
  end
end

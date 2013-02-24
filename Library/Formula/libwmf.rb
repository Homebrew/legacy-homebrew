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
<<<<<<< HEAD
<<<<<<< HEAD
                          "--with-freetype=#{MacOS::XQuartz.prefix}"
=======
                          "--with-freetype=#{MacOS::X11.prefix}"
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
=======
                          "--with-png=#{dep_prefix}",
                          "--with-freetype=#{dep_prefix}"
>>>>>>> 35b0414670cc73c4050f911c89fc1602fa6a1d40
    system "make"
    ENV.j1 # yet another rubbish Makefile
    system "make install"
  end
end

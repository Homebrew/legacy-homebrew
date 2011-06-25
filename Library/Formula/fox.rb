require 'formula'

class Fox < Formula
  url 'http://www.fox-toolkit.org/ftp/fox-1.7.23.tar.gz'
  homepage 'http://www.fox-toolkit.org/'
  md5 'ee8430d6480d3289d54b847f47405670'

  def install
    ENV.x11

    # Yep, won't find freetype unless this is all set.
    ENV.append "CFLAGS", "-I/usr/X11/include/freetype2"
    ENV.append "CPPFLAGS", "-I/usr/X11/include/freetype2"
    ENV.append "CXXFLAGS", "-I/usr/X11/include/freetype2"

    system "./configure", "--enable-release",
                          "--prefix=#{prefix}",
                          "--with-x", "--with-opengl"
    system "make install"
  end
end

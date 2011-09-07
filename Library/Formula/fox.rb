require 'formula'

class Fox < Formula
  url 'http://ftp.fox-toolkit.org/pub/fox-1.7.26.tar.gz'
  homepage 'http://www.fox-toolkit.org/'
  md5 'acaf8a1f33d02265b26a2b0c3fd06625'

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

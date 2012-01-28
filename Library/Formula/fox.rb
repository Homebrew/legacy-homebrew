require 'formula'

class Fox < Formula
  # Development and stable branches are incompatible
  url 'ftp://ftp.fox-toolkit.org/pub/fox-1.6.44.tar.gz'
  md5 '6ccc8cbcfa6e4c8b6e4deeeb39c36434'
  homepage 'http://www.fox-toolkit.org/'

  devel do
    url 'http://ftp.fox-toolkit.org/pub/fox-1.7.30.tar.gz'
    md5 '345df53f1e652bc99d1348444b4e3016'
  end

  fails_with_llvm "Inline asm errors during build" if ARGV.build_devel?

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

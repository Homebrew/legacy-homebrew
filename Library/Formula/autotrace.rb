require 'formula'

class Autotrace < Formula
  homepage 'http://autotrace.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/autotrace/AutoTrace/0.31.1/autotrace-0.31.1.tar.gz'
  sha1 '679e4912528030b86f23db5b99e60f8e7df883fd'

  option 'without-imagemagick', 'Compile without ImageMagick'

  depends_on 'imagemagick' unless build.include? 'without-imagemagick'

  def patches
    {
      # Issue 16569: Use MacPorts patch to port input-png.c to libpng 1.5.
      :p0 => 'https://trac.macports.org/export/100575/trunk/dports/graphics/autotrace/files/patch-libpng-1.5.diff'
    }
  end

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--mandir=#{man}"]

    args << "--without-magick" if build.include? 'without-imagemagick'

    system "./configure", *args
    system "make install"
  end
end

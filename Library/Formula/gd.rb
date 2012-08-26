require 'formula'

class Gd < Formula
  homepage 'http://bitbucket.org/pierrejoye/gd-libgd'
  url 'http://www.libgd.org/releases/gd-2.0.36RC1.tar.gz'
  mirror 'http://download.osgeo.org/mapserver/libgd/gd-2.0.36RC1.tar.gz'
  md5 '39ac48e6d5e0012a3bd2248a0102f209'

  head 'http://bitbucket.org/pierrejoye/gd-libgd', :using => :hg

  depends_on :x11
  depends_on 'jpeg' => :recommended

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
<<<<<<< HEAD
    system "./configure", "--prefix=#{prefix}", "--with-freetype=#{MacOS::XQuartz.prefix}"
=======
    system "./configure", "--prefix=#{prefix}", "--with-freetype=#{MacOS::X11.prefix}"
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
    system "make install"
    (lib+'pkgconfig/gdlib.pc').write pkg_file
  end

  def pkg_file; <<-EOF
prefix=#{prefix}
exec_prefix=${prefix}
libdir=/${exec_prefix}/lib
includedir=/${prefix}/include
bindir=/${prefix}/bin
ldflags=  -L/${prefix}/lib

Name: gd
Description: A graphics library for quick creation of PNG or JPEG images
Version: 2.0.36RC1
Requires:
Libs: -L${libdir} -lgd
Libs.private: -lXpm -lX11 -ljpeg -lfontconfig -lfreetype -lpng12 -lz -lm
Cflags: -I${includedir}
EOF
  end
end

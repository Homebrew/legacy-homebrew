require 'formula'

class Gd < Formula
  homepage 'http://bitbucket.org/pierrejoye/gd-libgd'
  url 'http://www.libgd.org/releases/gd-2.0.36RC1.tar.gz'
  mirror 'http://download.osgeo.org/mapserver/libgd/gd-2.0.36RC1.tar.gz'
  sha1 '21cf2ec93fd80836fc0cb4741201f7cc5440819a'

  head 'http://bitbucket.org/pierrejoye/gd-libgd', :using => :hg

  option 'without-libpng', 'Build without PNG support'
  option 'without-jpeg', 'Build without JPEG support'
  option 'with-freetype', 'Build with FreeType support'

  depends_on :libpng unless build.include? "without-libpng"
  depends_on 'jpeg' => :recommended unless build.include? "without-jpeg"
  depends_on :freetype if build.include? "with-freetype"

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--without-freetype" unless build.include? 'with-freetype'
    system "./configure", *args
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

  def test
    mktemp do
      system "#{bin}/pngtogd", \
        "/System/Library/Frameworks/SecurityInterface.framework/Versions/A/Resources/Key_Large.png", \
        "gd_test.gd"
      system "#{bin}/gdtopng", "gd_test.gd", "gd_test.png"
    end
  end
end

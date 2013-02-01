require 'formula'

class Gd < Formula
  homepage 'http://bitbucket.org/pierrejoye/gd-libgd'
  url 'http://www.libgd.org/releases/gd-2.0.36RC1.tar.gz'
  mirror 'http://download.osgeo.org/mapserver/libgd/gd-2.0.36RC1.tar.gz'
  sha1 '21cf2ec93fd80836fc0cb4741201f7cc5440819a'

  head 'http://bitbucket.org/pierrejoye/gd-libgd', :using => :hg

  depends_on :libpng => :recommended
  depends_on 'jpeg' => :recommended
  depends_on 'giflib' => :optional
  depends_on :freetype => :optional

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--without-freetype" unless build.with? 'freetype'
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
Libs.private: -ljpeg -lpng12 -lz -lm
Cflags: -I${includedir}
EOF
  end

  test do
    system "#{bin}/pngtogd", \
      "/System/Library/Frameworks/SecurityInterface.framework/Versions/A/Resources/Key_Large.png", \
      "gd_test.gd"
    system "#{bin}/gdtopng", "gd_test.gd", "gd_test.png"
  end
end

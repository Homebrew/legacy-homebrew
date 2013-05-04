require 'formula'

class Gd < Formula
  homepage 'https://bitbucket.org/libgd/gd-libgd'
  # libgd doesn't have their latest (non-alpha) version.
  # When they do release a stable version, use that url.
  # Watch this space: http://libgd.bitbucket.org/pages/downloads.html
  url 'http://download.osgeo.org/mapserver/libgd/gd-2.0.36RC1.tar.gz'
  sha1 '21cf2ec93fd80836fc0cb4741201f7cc5440819a'

  head 'https://bitbucket.org/libgd/gd-libgd', :using => :hg

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
    (lib+'pkgconfig/gdlib.pc').write pc_file
  end

  def pc_file; <<-EOS.undent
    prefix=#{opt_prefix}
    exec_prefix=${prefix}
    libdir=/${exec_prefix}/lib
    includedir=/${prefix}/include
    bindir=/${prefix}/bin
    ldflags=  -L/${prefix}/lib

    Name: gd
    Description: A graphics library for quick creation of PNG or JPEG images
    Version: #{version}
    Requires:
    Libs: -L${libdir} -lgd
    Libs.private: -ljpeg -lpng12 -lz -lm
    Cflags: -I${includedir}
    EOS
  end

  test do
    system "#{bin}/pngtogd", \
      "/System/Library/Frameworks/SecurityInterface.framework/Versions/A/Resources/Key_Large.png", \
      "gd_test.gd"
    system "#{bin}/gdtopng", "gd_test.gd", "gd_test.png"
  end
end

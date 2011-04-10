require 'formula'

class Gd < Formula
  # Official site has been down a lot, so use a mirror
  # homepage "http://www.libgd.org"
  # url "http://www.libgd.org/releases/gd-2.0.36RC1.tar.gz"

  homepage "http://bitbucket.org/pierrejoye/gd-libgd"
  url "http://ring.riken.jp/archives/graphics/gd/gd-2.0.36RC1.tar.gz"
  md5 "39ac48e6d5e0012a3bd2248a0102f209"

  head "http://bitbucket.org/pierrejoye/gd-libgd", :using => :hg

  depends_on 'jpeg' => :recommended

  fails_with_llvm "Undefined symbols when linking", :build => "2326"

  def install
    ENV.x11
    system "./configure", "--prefix=#{prefix}", "--with-freetype=/usr/X11"
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

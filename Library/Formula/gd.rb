require 'formula'

class Gd < Formula
  homepage 'http://libgd.bitbucket.org/'
  url 'https://bitbucket.org/libgd/gd-libgd/downloads/libgd-2.1.0.tar.gz'
  sha1 'a0f3053724403aef9e126f4aa5c662573e5836cd'
  revision 2

  bottle do
    cellar :any
    revision 1
    sha1 "370029d382be7ea5c8d5975f20b7668eced29f9c" => :yosemite
    sha1 "e183bfd8da0354da3e0b046f2d092b099f4c6356" => :mavericks
    sha1 "8fee5a15e1ed1331c52d9a286431fdd1b56c126e" => :mountain_lion
  end

  head 'https://bitbucket.org/libgd/gd-libgd', :using => :hg

  option :universal

  depends_on 'libpng' => :recommended
  depends_on 'jpeg' => :recommended
  depends_on 'fontconfig' => :recommended
  depends_on 'freetype' => :recommended
  depends_on 'libtiff' => :recommended
  depends_on 'libvpx' => :optional

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    ENV.universal_binary if build.universal?
    args = %W{--disable-dependency-tracking --prefix=#{prefix}}

    if build.with? "libpng"
      args << "--with-png=#{Formula["libpng"].opt_prefix}"
    else
      args << "--without-png"
    end

    if build.with? "fontconfig"
      args << "--with-fontconfig=#{Formula["fontconfig"].opt_prefix}"
    else
      args << "--without-fontconfig"
    end

    if build.with? "freetype"
      args << "--with-freetype=#{Formula["freetype"].opt_prefix}"
    else
      args << "--without-freetype"
    end

    if build.with? "jpeg"
      args << "--with-jpeg=#{Formula["jpeg"].opt_prefix}"
    else
      args << "--without-jpeg"
    end

    if build.with? "libtiff"
      args << "--with-tiff=#{Formula["libtiff"].opt_prefix}"
    else
      args << "--without-tiff"
    end

    if build.with? "libvpx"
      args << "--with-vpx=#{Formula["libvpx"].opt_prefix}"
    else
      args << "--without-vpx"
    end

    system "./configure", *args
    system "make install"
  end

  test do
    system "#{bin}/pngtogd", test_fixtures("test.png"), "gd_test.gd"
    system "#{bin}/gdtopng", "gd_test.gd", "gd_test.png"
  end
end

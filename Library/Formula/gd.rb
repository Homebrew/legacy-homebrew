class Gd < Formula
  desc "Graphics library to dynamically manipulate images"
  homepage "https://libgd.github.io/"
  url "https://github.com/konqui/libgd/releases/download/gd-2.1.1-rc1/libgd-2.1.1-rc1.tar.xz"
  sha256 "7fdb817edbc22452d04bf3cf7ad52a1e4a1304f69006e0efc9b623edaea24df7"

  bottle do
    cellar :any
    sha256 "07dcaf06b6f4b55fa209f1ad8a03ef549abfc789b820c7fc77762037337557df" => :el_capitan
    sha256 "acb0d79ec9ae9cbe1c114d0a772821036926dc8b2d5d09a9945037a49db21719" => :yosemite
    sha256 "7f96680ac98c529395492865f7a7ffe056e130a99c1006978682620dfa0da365" => :mavericks
  end

  head do
    url "https://bitbucket.org/libgd/gd-libgd.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "fontconfig" => :recommended
  depends_on "freetype" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "libvpx" => :optional

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    ENV.universal_binary if build.universal?

    args = %W[--disable-dependency-tracking --prefix=#{prefix}]

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

    system "./bootstrap.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/pngtogd", test_fixtures("test.png"), "gd_test.gd"
    system "#{bin}/gdtopng", "gd_test.gd", "gd_test.png"
  end
end

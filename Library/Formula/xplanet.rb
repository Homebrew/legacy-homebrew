class Xplanet < Formula
  desc "Create HQ wallpapers of planet Earth"
  homepage "http://xplanet.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xplanet/xplanet/1.3.0/xplanet-1.3.0.tar.gz"
  sha256 "44fb742bb93e5661ea8b11ccabcc12896693e051f3dd5083c9227224c416b442"
  revision 2

  bottle do
    sha256 "401b46887f90818530d5996e11ef2977481c51c85716e8da22e2dbaa454c01ab" => :yosemite
    sha256 "c0816c18de9ed0af9c7bee4e30498661cef65b0bfbea9901631740ce38edb4db" => :mavericks
    sha256 "6237bcf19e9337e706cfa80232e48aa5f74d52cdf9c6f092bb77b109352a8889" => :mountain_lion
  end

  option "with-x11", "Build for X11 instead of Aqua"
  option "with-all", "Build with default Xplanet configuration dependencies"
  option "with-pango", "Build Xplanet to support Internationalized text library"
  option "with-netpbm", "Build Xplanet with PNM graphic support"
  option "with-cspice", "Build Xplanet with JPLs SPICE toolkit support"

  depends_on "pkg-config" => :build

  depends_on "giflib" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended

  if build.with?("all")
    depends_on "netpbm"
    depends_on "pango"
    depends_on "cspice"
  end

  depends_on "netpbm" => :optional
  depends_on "pango" => :optional
  depends_on "cspice" => :optional

  depends_on "freetype"
  depends_on :x11 => :optional

  # support giflib 4.2.x http://sourceforge.net/p/xplanet/code/185/tree//trunk/src/libimage/gif.c?diff=5056482efd48f8457fc7910a:184
  patch do
    url "https://gist.githubusercontent.com/nijikon/e70275a4d9df4e4c6f1a/raw/f42e1b2e508c5f86c39ea20dd9315fd505d0a564/giflib-4.2.x.patch"
    sha256 "fcc998b9c728bc7232193ffb37d4f1b46fa6936f891345a3e28d0949f966bad4"
  end

  # support giflib 5.x http://sourceforge.net/p/xplanet/code/186/tree//trunk/src/libimage/gif.c?diff=5056482efd48f8457fc7910a:185
  patch do
    url "https://gist.githubusercontent.com/nijikon/e70275a4d9df4e4c6f1a/raw/e684b89b6841e15412199b5521c9822b78c19b5f/giflib-5.x.patch"
    sha256 "821366f67bacd1b863e48a70e5ba1df571f63df1a545800e424014d1160d3287"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-cygwin
    ]

    if build.without?("all")
      args << "--without-gif" if build.without?("giflib")
      args << "--without-jpeg" if build.without?("jpeg")
      args << "--without-libpng" if build.without?("libpng")
      args << "--without-libtiff" if build.without?("libtiff")
      args << "--without-pnm" if build.without?("netpbm")
      args << "--without-pango" if build.without?("pango")
      args << "--without-cspice" if build.without?("cspice")
    end

    if build.with?("x11")
      args << "--with-x" << "--with-xscreensaver" << "--without-aqua"
    else
      args << "--with-aqua" << "--without-x" << "--without-xscreensaver"
    end

    if build.with?("netpbm") || build.with?("all")
      netpbm = Formula["netpbm"].opt_prefix
      ENV.append "CPPFLAGS", "-I#{netpbm}/include/netpbm"
      ENV.append "LDFLAGS", "-L#{netpbm}/lib"
    end

    system "./configure", *args
    system "make", "install"
  end
end

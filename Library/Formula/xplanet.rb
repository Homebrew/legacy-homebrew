require "formula"

class Xplanet < Formula
  homepage "http://xplanet.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xplanet/xplanet/1.3.0/xplanet-1.3.0.tar.gz"
  sha1 "7c5208b501b441a0184cbb334a5658d0309d7dac"

  bottle do
    revision 2
    sha1 "f4494377cd80ce1332e9a171b914f9fa316406fb" => :mavericks
    sha1 "bb5488ef9be45bb605560c0af8d85b5e297984fc" => :mountain_lion
    sha1 "39f3137787a1f753d4fb083aaa05157368705fbd" => :lion
  end

  revision 1

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

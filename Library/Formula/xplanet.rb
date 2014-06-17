require "formula"

class Xplanet < Formula
  homepage "http://xplanet.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xplanet/xplanet/1.3.0/xplanet-1.3.0.tar.gz"
  sha1 "7c5208b501b441a0184cbb334a5658d0309d7dac"

  bottle do
    revision 1
    sha1 "003d49a9e2828d654c9b2e890588e9991c1cab8d" => :mavericks
    sha1 "1952b8a4443ff14f286fabdcb112e144b2f1f707" => :mountain_lion
    sha1 "34632a0943e30fee6f41c02f022bceb6413c4c54" => :lion
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

  depends_on "netpbm" if build.with?("netpbm") || build.with?("all")
  depends_on "pango" if build.with?("pango") || build.with?("all")
  depends_on "cspice" if build.with?("cspice") || build.with?("all")

  depends_on "freetype"
  depends_on :x11 => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.with? "x11"
      args << "--with-x"
    else
      args << "--with-aqua" << "--without-x"
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

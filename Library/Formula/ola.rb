class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.10.1/ola-0.10.1.tar.gz"
  sha256 "621f18f591a418236595d0117b4ab16d8e39a69b03071e62fdae0e9b01533de0"

  bottle do
    sha256 "03f1e69ea600927d840a5f1fe1a9932256fbd3b37530cd262caf641b4ae6db89" => :el_capitan
    sha256 "38cc4502fa98c4afe97a2d1d8919508fda999a08cabc1af2bc19e0a6d6bb69a2" => :yosemite
    sha256 "fff088b40bc18986aa3dfa1a90500727f90d6ef637890dc4a973e806b67ed525" => :mavericks
  end

  head do
    url "https://github.com/OpenLightingProject/ola.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal
  option "with-ftdi", "Install FTDI USB plugin for OLA."
  # RDM tests require protobuf-c --with-python to work
  option "with-rdm-tests", "Install RDM Tests for OLA."

  depends_on "pkg-config" => :build
  depends_on "cppunit"
  depends_on "protobuf-c"
  depends_on "libmicrohttpd"
  depends_on "ossp-uuid"
  depends_on "libusb" => :recommended
  depends_on "liblo" => :recommended
  depends_on "doxygen" => :optional

  if build.with? "ftdi"
    depends_on "libftdi"
    depends_on "libftdi0"
  end

  if build.with? "rdm-tests"
    depends_on :python if MacOS.version <= :snow_leopard
  else
    depends_on :python => :optional
  end

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --disable-fatal-warnings
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    args << "--enable-python-libs" if build.with? "python"
    args << "--enable-rdm-tests" if build.with? "rdm-tests"
    args << "--enable-doxygen-man" if build.with? "doxygen"

    system "autoreconf", "-fvi" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"ola_plugin_info"
  end
end

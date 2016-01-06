class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.10.0/ola-0.10.0.tar.gz"
  sha256 "cae8131a62f0ff78d399c42e64a51b610d7cf090b606704081ec9dd2cf979883"

  bottle do
    sha256 "4c0dcbbe74d138186ef816ba9fa7466e53eb163bae621192c0dc1263953c608d" => :el_capitan
    sha256 "1c0b656498320bab779d3bdf3381bf42e60753d749117cb7c4870a990ce9dc4b" => :yosemite
    sha256 "c8949959491ad8ffa3f3fb2d7a9b94b671d48662a24e492712821447008e0bca" => :mavericks
  end

  head do
    url "https://github.com/OpenLightingProject/ola.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal
  option "with-ftdi", "Install FTDI USB plugin for OLA."

  depends_on "pkg-config" => :build
  depends_on "cppunit"
  depends_on "protobuf-c"
  depends_on "libmicrohttpd"
  depends_on "libusb"
  depends_on "liblo"
  depends_on "ossp-uuid"
  depends_on :python => :optional
  depends_on "doxygen" => :optional
  if build.with? "ftdi"
    depends_on "libftdi"
    depends_on "libftdi0"
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
    args << "--enable-doxygen-man" if build.with? "doxygen"

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"ola_plugin_info"
  end
end

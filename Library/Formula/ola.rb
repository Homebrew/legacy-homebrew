class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.9.8/ola-0.9.8.tar.gz"
  sha256 "1c1e0fc1810b0c0857563bc481c872b8ed5d2e62c97c1083c82eabd7ebbd70a6"
  revision 1

  bottle do
    sha256 "4cdc7b5055bdbc0242a1d424b7436cbdac39f60d38f259931ff0b86b58e2b42a" => :el_capitan
    sha256 "848b12a934e10cdc179d1013ba0ac8d1770d27a2bdc90ffcd515c5dfe9203047" => :yosemite
    sha256 "f341009e874078f04be3d84e95a28331df3f372ac53241f54c4a63b4eae5e9dd" => :mavericks
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

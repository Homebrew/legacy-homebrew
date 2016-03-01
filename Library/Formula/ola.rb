class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.10.0/ola-0.10.0.tar.gz"
  sha256 "cae8131a62f0ff78d399c42e64a51b610d7cf090b606704081ec9dd2cf979883"

  bottle do
    sha256 "48b73cfefda79be164fe9d201f4906bab1bd6b341979646ae346471fd2bc0101" => :el_capitan
    sha256 "f9bf56339fc7d740a1a0f02c59f7adfe87aaf9e66ad45ddb1b6f1f2238651117" => :yosemite
    sha256 "686c400e0ebd09cdc2513981b20abd125161ca5098495328767fd00e149481ef" => :mavericks
  end

  head do
    url "https://github.com/OpenLightingProject/ola.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal
  option "with-ftdi", "Install FTDI USB plugin for OLA."
  option "with-rdm-tests", "Install RDM Tests for OLA."
  # RDM tests require protobuf-c --with-python to work

  depends_on "pkg-config" => :build
  depends_on "cppunit"
  depends_on "protobuf-c"
  depends_on "libmicrohttpd"
  depends_on "ossp-uuid"
  depends_on "libusb" => :recommended
  depends_on "liblo" => :recommended
  depends_on :python => :optional
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

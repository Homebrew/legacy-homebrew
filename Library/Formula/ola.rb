class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.10.0/ola-0.10.0.tar.gz"
  sha256 "cae8131a62f0ff78d399c42e64a51b610d7cf090b606704081ec9dd2cf979883"

  bottle do
    revision 1
    sha256 "7394b7d40508caad493bf6a557fd6f8b665789d7e4c926410d7740a315f08100" => :el_capitan
    sha256 "19550bb06b7311c88267dc3f203d99e3b60975cf6cd0f0e03c8ea5d19ab29e80" => :yosemite
    sha256 "c9e27ebf54e28dc0773e15c1a35ce19bbe7fb899c918d66a27556ae8ca420aa3" => :mavericks
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

require "formula"

class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "http://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.9.5/ola-0.9.5.tar.gz"
  sha256 "7c24ac98e865b4c354a04563b88012e782205ffd932a05cf944273f6f5ea82ca"

  bottle do
    sha256 "d2a19c0604c17fe15625ffff673a059f61fb3357888df98cac4086dff864ba72" => :yosemite
    sha256 "9639aeaac22b83aa720a043485cb729ca014a4180ff08dc7fca327217e1bc69b" => :mavericks
    sha256 "693db3e8b52354d1a5924afddbca2231475a30fe0b11b236b833baedccb0fc5f" => :mountain_lion
  end

  head do
    url "https://github.com/OpenLightingProject/ola.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "cppunit"
  depends_on "protobuf-c"
  depends_on "libmicrohttpd"
  depends_on "libusb"
  depends_on "liblo"
  depends_on "ossp-uuid"
  depends_on :python => :optional
  depends_on "doxygen" => :optional

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

require "formula"

class Ola < Formula
  homepage "http://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.9.3/ola-0.9.3.tar.gz"
  sha1 "f6a81087761218063a4bb8006b73ffa407cd0170"

  bottle do
    sha1 "084b25099b2eaf5d90a69ebc20b43c0cf338b614" => :yosemite
    sha1 "64e7e1a34c1840a7315449a3cc037f07bb75407a" => :mavericks
    sha1 "4a4d4b3b9909d0e40b9c4658fc7f41713bc20a0a" => :mountain_lion
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

require "formula"

class Ola < Formula
  homepage "http://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.9.1/ola-0.9.1.tar.gz"
  sha1 "1aeb969d833385603504f9debcbf48d7b27b5200"

  bottle do
    sha1 "415969ef130bc2a386c92fd44689dc41d824bce2" => :mavericks
    sha1 "7728260e561148e324290c2d0b34320de94028c9" => :mountain_lion
    sha1 "bae4d5c8d4d3386976a82d65a7a3691adafaa589" => :lion
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "cppunit"
  depends_on "protobuf-c"
  depends_on "libmicrohttpd"
  depends_on "libusb"
  depends_on "liblo"
  depends_on :python => :optional

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --disable-debug
      --disable-fatal-warnings
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]
    args << "--enable-python-libs" if build.with? "python"

    system "./configure", *args

    system "make", "install"
  end

  test do
    system bin/"ola_plugin_info"
  end
end

require "formula"

class Ola < Formula
  homepage "http://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.9.1/ola-0.9.1.tar.gz"
  sha1 "1aeb969d833385603504f9debcbf48d7b27b5200"
  revision 1

  bottle do
    sha1 "c2b8f0cdc56866d521557b9827d1285e89e42de8" => :mavericks
    sha1 "a9b7f59e3e76c2119eca3b20e3193d20ed8218ca" => :mountain_lion
    sha1 "d2a7b940ab4b72b8a6c061c3c590bcf925907d70" => :lion
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

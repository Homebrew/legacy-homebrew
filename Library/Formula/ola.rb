require "formula"

class Ola < Formula
  homepage "http://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.9.2/ola-0.9.2.tar.gz"
  sha1 "f9cedbb9bf8e568803f296b7ec8bdfcf74ae5bab"

  bottle do
    sha1 "d9f67796fc3228e94d07cead6a91dfccbe3a2f2b" => :mavericks
    sha1 "1b2577335ce33aa83e4bceb27260a585bce06b91" => :mountain_lion
    sha1 "de23fe04b9a29273c61d58287d540f90db9ab662" => :lion
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

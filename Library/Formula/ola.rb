require "formula"

class Ola < Formula
  homepage "http://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.9.3/ola-0.9.3.tar.gz"
  sha1 "f6a81087761218063a4bb8006b73ffa407cd0170"

  bottle do
    sha1 "d9f67796fc3228e94d07cead6a91dfccbe3a2f2b" => :mavericks
    sha1 "1b2577335ce33aa83e4bceb27260a585bce06b91" => :mountain_lion
    sha1 "de23fe04b9a29273c61d58287d540f90db9ab662" => :lion
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

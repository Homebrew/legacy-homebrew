require "formula"

class Ola < Formula
  homepage "http://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.9.0/ola-0.9.0.tar.gz"
  sha1 "aff9bf0802d4e6fcbdc5a2ffcdb7ba25d67fd209"

  bottle do
    sha1 "6e6b052f3c4f7dd4f413be82bc8858265c156e56" => :mavericks
    sha1 "4104956ee3b641f353bc4d24c5edcf9c6888d3e8" => :mountain_lion
    sha1 "449b86401a2aa4ac6445a7839fe82035a747d264" => :lion
  end

  option :universal

  depends_on 'pkg-config' => :build
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

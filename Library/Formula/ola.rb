require "formula"

class Ola < Formula
  homepage "http://www.openlighting.org"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.9.0/ola-0.9.0.tar.gz"
  sha1 "aff9bf0802d4e6fcbdc5a2ffcdb7ba25d67fd209"

  require_universal_deps

  depends_on 'pkg-config' => :build
  depends_on "cppunit"
  depends_on "protobuf-c"
  depends_on "libmicrohttpd"
  depends_on "libusb"
  depends_on "liblo"

  def install
    ENV.universal_binary if build.universal?

    build32 = "-arch i386 -m32"
    ENV.append 'CFLAGS', build32
    ENV.append 'LDFLAGS', build32


    system "./configure", "--disable-debug",
                          "--disable-fatal-warnings",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system "make check"
  end
end

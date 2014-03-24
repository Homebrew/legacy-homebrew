require "formula"

class Ola < Formula
  homepage "http://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.9.0/ola-0.9.0.tar.gz"
  sha1 "aff9bf0802d4e6fcbdc5a2ffcdb7ba25d67fd209"

  option "with-tests", "runs extra tests during install"

  depends_on "cppunit" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => "with-python"
  depends_on "libmicrohttpd" => :recommended
  depends_on "libusb" => :recommended

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-python-libs",
                          "--disable-slp"
    system "make", "install"

    if build.with? 'tests'
      ENV.deparallelize
      system "make", "distcheck"
    end

  end

  test do
    system "#{bin}/ola_dmxconsole", "--help"
  end
end

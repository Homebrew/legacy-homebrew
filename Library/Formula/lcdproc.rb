class Lcdproc < Formula
  desc "Display real-time system information on a LCD"
  homepage "http://www.lcdproc.org/"
  url "https://downloads.sourceforge.net/project/lcdproc/lcdproc/0.5.6/lcdproc-0.5.6.tar.gz"
  sha256 "bd2f43c30ff43b30f43110abe6b4a5bc8e0267cb9f57fa97cc5e5ef9488b984a"

  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "libhid"
  depends_on "libftdi0"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-drivers=all",
                          "--enable-libftdi=yes"
    system "make"
    system "make", "install"
  end
end

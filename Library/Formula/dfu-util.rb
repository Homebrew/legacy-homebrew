require "formula"

class DfuUtil < Formula
  homepage "https://gitorious.org/dfu-util/community"
  # upstream moved, no releases yet, using debian mirror until then.  see #34047
  url "http://ftp.de.debian.org/debian/pool/main/d/dfu-util/dfu-util_0.8.orig.tar.gz"
  sha1 "164551ca40f0c569eb7ae3263a9945a1ef3fed4d"

  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

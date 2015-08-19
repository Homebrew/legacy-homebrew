# This fork contains OS X patches.
# Original project: https://github.com/roysjosh/xbee-comm

class XbeeComm < Formula
  desc "XBee communication libraries and utilities"
  homepage "https://github.com/guyzmo/xbee-comm.git"
  url "https://github.com/guyzmo/xbee-comm/archive/v1.5.tar.gz"
  sha256 "c474d22feae5d9c05b3ec167b839c8fded512587da0f020ca682d60db174f24a"

  head "https://github.com/guyzmo/xbee-comm.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "aclocal"
    system "autoconf"
    system "autoheader"
    system "automake", "-a", "-c"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

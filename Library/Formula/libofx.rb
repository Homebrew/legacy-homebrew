class Libofx < Formula
  desc "Library to support OFX command responses"
  homepage "http://libofx.sourceforge.net"
  url "https://downloads.sourceforge.net/project/libofx/libofx/0.9.9/libofx-0.9.9.tar.gz"
  sha256 "94ef88c5cdc3e307e473fa2a55d4a05da802ee2feb65c85c63b9019c83747b23"

  bottle do
    revision 1
    sha256 "cb45299c0a279d0cf67a3f0de1875b78f6944cf899ae9844ba6cfc8f39689599" => :el_capitan
    sha256 "5d29ae89fa771229fd80ce514db0303507a51f2bd3a32ea85f4db4727e11a59b" => :yosemite
    sha256 "deddd527249a7d2a77772c42d656e4b44ea54a7b122da6b485594947927ec49b" => :mavericks
    sha256 "88f857936a621b9ee2b09b7e0d2412673d49271e3528507c2071619490dc3534" => :mountain_lion
  end

  depends_on "open-sp"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

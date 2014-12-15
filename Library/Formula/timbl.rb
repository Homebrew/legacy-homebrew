require "formula"

class Timbl < Formula
  homepage "http://ilk.uvt.nl/timbl/"
  url "http://software.ticc.uvt.nl/timbl-6.4.6.tar.gz"
  sha1 "9ab67a9a10830ba32eca8529accbc167ee5649a2"

  depends_on "pkg-config" => :build
  depends_on "libxml2"
  depends_on "ticcutils"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

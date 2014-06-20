require "formula"

class Geomview < Formula
  homepage "http://www.geomview.org"
  url "https://downloads.sourceforge.net/project/geomview/geomview/1.9.5/geomview-1.9.5.tar.gz"
  sha1 "26186046dc18ab3872e7104745ae474908ee54d1"

  depends_on :x11
  depends_on "lesstif"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

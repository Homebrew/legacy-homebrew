require "formula"

class Libical < Formula
  homepage "http://www.citadel.org/doku.php/documentation:featured_projects:libical"
  url "https://downloads.sourceforge.net/project/freeassociation/libical/libical-1.0/libical-1.0.tar.gz"
  sha1 "25c75f6f947edb6347404a958b1444cceeb9f117"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

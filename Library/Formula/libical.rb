require "formula"

class Libical < Formula
  homepage "http://www.citadel.org/doku.php/documentation:featured_projects:libical"
  url "https://downloads.sourceforge.net/project/freeassociation/libical/libical-1.0/libical-1.0.tar.gz"
  sha1 "25c75f6f947edb6347404a958b1444cceeb9f117"

  bottle do
    revision 1
    sha1 "18d0e60043b3b78eb6872f53a0508537d7fcd5db" => :yosemite
    sha1 "cea6dad5171431e1f7a5d7e12beb7c6eb4c3951c" => :mavericks
    sha1 "e19ed113cb312dfeea12fba84f21f29f5866db99" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

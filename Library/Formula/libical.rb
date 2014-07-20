require "formula"

class Libical < Formula
  homepage "http://www.citadel.org/doku.php/documentation:featured_projects:libical"
  url "https://downloads.sourceforge.net/project/freeassociation/libical/libical-1.0/libical-1.0.tar.gz"
  sha1 "25c75f6f947edb6347404a958b1444cceeb9f117"

  bottle do
    sha1 "53a9904cb6430f736cf154bacfa425e09a6b1d73" => :mavericks
    sha1 "17d644dc8d704576d66807be82a82ff18e19feb6" => :mountain_lion
    sha1 "60b0f803e80ad08fda001af2f54b0cbcb257f935" => :lion
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

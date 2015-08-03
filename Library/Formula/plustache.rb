class Plustache < Formula
  desc "C++ port of Mustache templating system"
  homepage "https://github.com/mrtazz/plustache"
  url "https://github.com/mrtazz/plustache/archive/v0.3.0.tar.gz"
  sha256 "ceb56d6cab81b8ed2d812e4a546036a46dd28685512255e3f52553ba70a15fc8"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "boost"

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end

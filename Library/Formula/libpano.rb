class Libpano < Formula
  desc "Build panoramic images from a set of overlapping images"
  homepage "http://panotools.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/panotools/libpano13/libpano13-2.9.19/libpano13-2.9.19.tar.gz"
  version "13-2.9.19"
  sha256 "037357383978341dea8f572a5d2a0876c5ab0a83dffda431bd393357e91d95a8"
  bottle do
    cellar :any
    sha256 "835f1cb01acb3a1f1093df06fc0b940bb4e224e7abb9ee67d131a43d428eb373" => :yosemite
    sha256 "ef50d747fa8f71bb1f4bb9db5689c1456666dfd7df31c5c49f144174d9889900" => :mavericks
    sha256 "232a6489290f8dfd237f19de0ece39a53bf15d8385fd936bfb738b93b15d01ce" => :mountain_lion
  end

  revision 1

  depends_on "libpng"
  depends_on "jpeg"
  depends_on "libtiff"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end

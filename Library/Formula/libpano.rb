class Libpano < Formula
  desc "Build panoramic images from a set of overlapping images"
  homepage "http://panotools.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/panotools/libpano13/libpano13-2.9.19/libpano13-2.9.19.tar.gz"
  version "13-2.9.19"
  sha256 "037357383978341dea8f572a5d2a0876c5ab0a83dffda431bd393357e91d95a8"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "a4920c760a4aff60251d8876499ae14eeb52dd4f17adc5a19d14d2f79959590d" => :el_capitan
    sha256 "9188bc29e6e0b271cea0e3b017c0f222825d49bf67d1f65f2a2ecbde6bf870ea" => :yosemite
    sha256 "cfba56608e1be4c285ad75dd67299405384b690b8cad0d397859a4e29f7f2e9c" => :mavericks
  end

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

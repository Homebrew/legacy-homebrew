class Libpano < Formula
  desc "Build panoramic images from a set of overlapping images"
  homepage "http://panotools.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/panotools/libpano13/libpano13-2.9.19/libpano13-2.9.19.tar.gz"
  version "13-2.9.19"
  sha256 "037357383978341dea8f572a5d2a0876c5ab0a83dffda431bd393357e91d95a8"
  bottle do
    cellar :any
    sha1 "b1e5da01e08bec1f5ca739a85a7d4c979bca21d6" => :yosemite
    sha1 "ff85fcab7a27810d027116abaccf9362101780c9" => :mavericks
    sha1 "0ea739e0ad708cc3d48d48eb542cb726e705ea2a" => :mountain_lion
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

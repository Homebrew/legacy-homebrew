class Libnxml < Formula
  desc "C library for parsing, writing, and creating XML files"
  homepage "http://www.autistici.org/bakunin/libnxml/"
  url "http://www.autistici.org/bakunin/libnxml/libnxml-0.18.3.tar.gz"
  sha256 "0f9460e3ba16b347001caf6843f0050f5482e36ebcb307f709259fd6575aa547"

  bottle do
    cellar :any
    revision 1
    sha256 "7c2bff9c49c93ef6a3901050212671c60e0cb4e72f2faf968eb4ae57f3d6fbeb" => :yosemite
    sha256 "49cfdc9ab57c78deed6b2fc3ce1c13b48a943384b2d366f9c37cfb673528b637" => :mavericks
    sha256 "6625f30468eb89a785443261aa63a4f69267cd72338a3acb604326245566e3f8" => :mountain_lion
  end

  depends_on "curl" if MacOS.version < :lion # needs >= v7.20.1

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

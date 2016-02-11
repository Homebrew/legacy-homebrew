class Exempi < Formula
  desc "Library to parse XMP metadata"
  homepage "https://wiki.freedesktop.org/libopenraw/Exempi/"
  url "https://libopenraw.freedesktop.org/download/exempi-2.2.2.tar.bz2"
  sha256 "0e7ad0e5e61b6828e38d31a8cc59c26c9adeed7edf4b26708c400beb6a686c07"

  bottle do
    cellar :any
    revision 1
    sha256 "f206518cc6c975db238ddfddeb7651cbab3f8a5a7a209027e0338b42713ed09a" => :el_capitan
    sha256 "1106514a966a9448cd11af1ee631e761ff96a55ca28f93d904d27320c253ef0b" => :yosemite
    sha256 "e382edc9229c007bc38c2211ea703e97a149133fbb260601b45d8543301e85b8" => :mavericks
  end

  depends_on "boost"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end
end

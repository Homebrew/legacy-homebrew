class Ufraw < Formula
  desc "Unidentified Flying RAW: RAW image processing utility"
  homepage "http://ufraw.sourceforge.net"
  url "https://downloads.sourceforge.net/project/ufraw/ufraw/ufraw-0.22/ufraw-0.22.tar.gz"
  sha256 "f7abd28ce587db2a74b4c54149bd8a2523a7ddc09bedf4f923246ff0ae09a25e"

  bottle do
    sha256 "5462d1df3236f497fbae4171b743e598107224abce9ba274ef8c783153c3e41d" => :el_capitan
    sha256 "21f29f6ffe796c76d3d47ba11923f61c9cc69980bb7175ad24ea9d38e88a95a7" => :yosemite
    sha256 "caf38b978cd614b51eb038f2bdac1cf6c5dfb8697adcae71f7cefceb9a4a2f07" => :mavericks
    sha256 "549b1471b35978a9695f4ea75044f233e782d32628fe0b86e389583e977f7219" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "dcraw"
  depends_on "glib"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "little-cms"
  depends_on "exiv2" => :optional

  fails_with :llvm do
    cause "Segfault while linking"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-gtk",
                          "--without-gimp"
    system "make", "install"
    (share+"pixmaps").rmtree
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ufraw-batch --version 2>&1")
  end
end

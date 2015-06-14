class Ufraw < Formula
  desc "Unidentified Flying RAW: RAW image processing utility"
  homepage "http://ufraw.sourceforge.net"
  url "https://downloads.sourceforge.net/project/ufraw/ufraw/ufraw-0.21/ufraw-0.21.tar.gz"
  sha256 "2a6a1bcc633bdc8e15615cf726befcd7f27ab00e7c2a518469a24e1a96964d87"

  bottle do
    sha256 "08672a5a059ad9736b43b426343e7c98f85879fcbd1c97786fc931b70fade99c" => :yosemite
    sha256 "8fd7723a81578679c7f5c9f8b1739d75b745cf53deb78203856d3e6fc5270bba" => :mavericks
    sha256 "3233bc9d19aa79d7453f8d112629fd24802c7539dc3232ed07635585e1c0bc06" => :mountain_lion
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

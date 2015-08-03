class Evas < Formula
  desc "Display canvas API that implements a scene graph"
  homepage "https://docs.enlightenment.org/auto/eet/evas_main.html"
  url "https://download.enlightenment.org/releases/evas-1.7.10.tar.gz"
  sha256 "9c6c8679608ab0f2aa78e83f2ac1f9133d5bb615dabd5491bbbd30fcec4fc82b"

  bottle do
    sha1 "2d46e4ae7cbd297b1937c6a0776cc0008f6c35f6" => :yosemite
    sha1 "f13c2631054365b846063b1cf760aae5116afae8" => :mavericks
    sha1 "2609ecbe2a0be5843674f59606d15ce1ee097699" => :mountain_lion
  end

  option "with-docs", "Install development libraries/headers and HTML docs"

  depends_on "pkg-config" => :build
  depends_on "eina"
  depends_on "eet"
  depends_on "freetype"
  depends_on "fontconfig"
  depends_on "fribidi"
  depends_on "harfbuzz"
  depends_on "doxygen" => :build if build.with? "docs"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    system "make", "install-doc" if build.with? "docs"
  end
end

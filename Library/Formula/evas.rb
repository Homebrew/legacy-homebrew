class Evas < Formula
  desc "Display canvas API that implements a scene graph"
  homepage "https://docs.enlightenment.org/auto/eet/evas_main.html"
  url "https://download.enlightenment.org/releases/evas-1.7.10.tar.gz"
  sha256 "9c6c8679608ab0f2aa78e83f2ac1f9133d5bb615dabd5491bbbd30fcec4fc82b"

  bottle do
    sha256 "1ac0564c2241cef362a072490d02151bfa69ae1d1b2c0a592d34f5b2ca6d3fe2" => :el_capitan
    sha256 "093a8fd311b0a6ab054dad8b5990fe1f901d18b942265d32b60a572bdfc5689d" => :yosemite
    sha256 "27c30e2f0e52e7a3141f6dceca0daaf53cf34c50ecfef64aadb6b9774088b3ed" => :mavericks
    sha256 "71e90d343bd3355ff57bdf84fb7ffdad0e8e060cdfc13c887216bd94b5f317c9" => :mountain_lion
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

require "formula"

class Synfig < Formula
  homepage "http://synfig.org"
  url "https://downloads.sourceforge.net/project/synfig/releases/0.64.3/source/synfig-0.64.3.tar.gz"
  sha1 "868e55dcac9ecda93c6f4aa2d842713f5b77df8d"

  head "git://synfig.git.sourceforge.net/gitroot/synfig/synfig"

  bottle do
    sha1 "89c964ef3cf533bf684f068edf859e8fcffeab3e" => :yosemite
    sha1 "e18ee1a88afa30edf481230dfb61ee35eab8d76a" => :mavericks
    sha1 "678579ebdb05f32f405fde48151ef3523a9249fc" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "etl"
  depends_on "libsigc++"
  depends_on "libxml++"
  depends_on "imagemagick"
  depends_on "libpng"
  depends_on "freetype"
  depends_on "cairo"
  depends_on "pango"
  depends_on "boost"
  depends_on "openexr"
  depends_on "libtool" => :run

  def install
    boost = Formula["boost"]
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{boost.opt_prefix}"
    system "make install"
  end
end

require "formula"

class Synfig < Formula
  homepage "http://synfig.org"
  url "https://downloads.sourceforge.net/project/synfig/releases/0.64.3/source/synfig-0.64.3.tar.gz"
  sha1 "868e55dcac9ecda93c6f4aa2d842713f5b77df8d"

  head "git://synfig.git.sourceforge.net/gitroot/synfig/synfig"

  bottle do
    sha1 "1353dc1b8855ae972fe5b2aa74c4725c919ec233" => :yosemite
    sha1 "f5d93ec9e09a37b0d9529d6282395facba82d9e0" => :mavericks
    sha1 "0feeffbb682c86a11fae0a405232fb3f5d67f51d" => :mountain_lion
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

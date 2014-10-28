require "formula"

class Synfig < Formula
  homepage "http://synfig.org"
  url "https://downloads.sourceforge.net/project/synfig/releases/0.64.2/source/synfig-0.64.2.tar.gz"
  sha1 "57eeea0ac92437b909f0aeeee0ec939f03b2555f"

  head "git://synfig.git.sourceforge.net/gitroot/synfig/synfig"

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

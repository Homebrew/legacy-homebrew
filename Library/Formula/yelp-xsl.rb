class YelpXsl < Formula
  desc "Yelp's universal stylesheets for Mallard and DocBook"
  homepage "https://github.com/GNOME/yelp-xsl"
  url "https://download.gnome.org/sources/yelp-xsl/3.16/yelp-xsl-3.16.1.tar.xz"
  sha256 "3295eecc4b03d2a239f7a1bdf4a1311d34c46c3055e6535c1f72bb5a49b4174a"

  bottle do
    cellar :any
    sha256 "7517192fb0c5b6bc6d5133486cb460fc25cb9e12327752401c34f38045030518" => :yosemite
    sha256 "e8cba6dd4211955a183b926eeb6aa2ba1aafe7571d129029eb8d8b5492adea0d" => :mavericks
    sha256 "ce9aa0d02239264b3a651cfe5d13f1675bb276325a079de5efca83a1940f29cb" => :mountain_lion
  end

  depends_on "libxslt"
  depends_on "libxml2"
  depends_on "itstool" => :build
  depends_on "intltool" => :build
  depends_on "gettext" => :build
  depends_on "gtk+3"=> :run

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert (share/"yelp-xsl/xslt/mallard/html/mal2html-links.xsl").exist?
    assert (share/"yelp-xsl/js/jquery.syntax.brush.smalltalk.js").exist?
    assert (share/"yelp-xsl/icons/hicolor/24x24/status/yelp-note-warning.png").exist?
    assert (share/"pkgconfig/yelp-xsl.pc").exist?
  end
end

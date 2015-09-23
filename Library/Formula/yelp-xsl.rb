class YelpXsl < Formula
  desc "Yelp's universal stylesheets for Mallard and DocBook"
  homepage "https://github.com/GNOME/yelp-xsl"
  url "https://download.gnome.org/sources/yelp-xsl/3.18/yelp-xsl-3.18.0.tar.xz"
  sha256 "893620857b72b3b43ee3b462281240b7ca4d80292f469552827f0597bf60d2b2"

  bottle do
    cellar :any_skip_relocation
    sha256 "24794801c092eb5ba137dea398667311f7fb75883abcf88535a53c37611a6b7b" => :el_capitan
    sha256 "29782d18e554b1470bbe76d7980caca6bc9cb770c586ea982811ad203f845765" => :yosemite
    sha256 "686ffd08b13e414afca2851c2d61f7208e1349d1c23386613127ee9ff57b7c96" => :mavericks
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

class YelpXsl < Formula
  desc "Yelp's universal stylesheets for Mallard and DocBook"
  homepage "https://github.com/GNOME/yelp-xsl"
  url "https://download.gnome.org/sources/yelp-xsl/3.18/yelp-xsl-3.18.1.tar.xz"
  sha256 "00870fbe59a1bc7797b385fce16386917e2987c404e9b5a7adcf0036f1c1ba62"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c6aebcb7310ad6451c2410da48bdd43bd0b595ad6608ced1a787ad7307add57" => :el_capitan
    sha256 "2a596d1ffc199375109a990a397a289a28530c1d6af7b79db443208f6b9f6c23" => :yosemite
    sha256 "155670c085ed84002b69978bd679ff128a8be811fc686b8b0936cbae9634ad20" => :mavericks
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

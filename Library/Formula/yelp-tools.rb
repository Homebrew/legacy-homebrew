class YelpTools < Formula
  desc "Tools that help create and edit Mallard or DocBook documentation."
  homepage "https://github.com/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/3.16/yelp-tools-3.16.1.tar.xz"
  sha256 "b4f66c145af1c6448dc51037d305d6844da13dc31d07729b8e29005ee4fef89c"

  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "libxslt" => :build
  depends_on "libxml2" => :build
  depends_on "yelp-xsl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/yelp-new", "task", "ducksinarow"
    system "#{bin}/yelp-build", "html", "ducksinarow.page"
    system "#{bin}/yelp-check", "validate", "ducksinarow.page"
  end
end

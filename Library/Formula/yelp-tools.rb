class YelpTools < Formula
  desc "Tools that help create and edit Mallard or DocBook documentation."
  homepage "https://github.com/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/3.18/yelp-tools-3.18.0.tar.xz"
  sha256 "c6c1d65f802397267cdc47aafd5398c4b60766e0a7ad2190426af6c0d0716932"

  bottle do
    sha256 "7894b375bb21f2929d52059e03c7f2e85d3f1b01a3628713bab9f8b22046177a" => :yosemite
    sha256 "58b3f9a45cd49310e5927fb646ce7377217def692721b1b44c8ccb83ed25baa6" => :mavericks
    sha256 "e563248856c8bf11c35b426147884e148207065de6e4adf8920fd4cdf9353207" => :mountain_lion
  end

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

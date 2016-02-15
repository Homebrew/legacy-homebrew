class YelpTools < Formula
  desc "Tools that help create and edit Mallard or DocBook documentation."
  homepage "https://github.com/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/3.18/yelp-tools-3.18.0.tar.xz"
  sha256 "c6c1d65f802397267cdc47aafd5398c4b60766e0a7ad2190426af6c0d0716932"

  bottle do
    cellar :any_skip_relocation
    sha256 "8191df226586af990aaf4be1cacc3e3a5b26091c138bd7d3e0e595e1792151dd" => :el_capitan
    sha256 "93dd1e36f80961f722bf2b1ec18b66dab947984858ba3aa084e852dcdafa92bc" => :yosemite
    sha256 "66721baa2d6c6978cceac29f35e8112e96804b6ae0197d89175867f17caca2cd" => :mavericks
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

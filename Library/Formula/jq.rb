class Jq < Formula
  desc "Lightweight and flexible command-line JSON processor"
  homepage "https://stedolan.github.io/jq/"
  url "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-1.5.tar.gz"
  sha256 "c4d2bfec6436341113419debf479d833692cc5cdab7eb0326b5a4d4fbe9f493c"

  bottle do
    cellar :any
    sha256 "d82e4bc06b13f3141824d292acf0c71d03cb9c868f1058e9609a8eee4856bb61" => :yosemite
    sha256 "662334064582cf503ffdde34b111c7246e493871c2dbaac4226a9f27ae41f38f" => :mavericks
    sha256 "ba9d088255020c62566e3fafabf5ffaf8080ec264dcad205240f5b7fdbedd4a6" => :mountain_lion
  end

  head do
    url "https://github.com/stedolan/jq.git"
  end

  depends_on "oniguruma"  # jq depends > 1.5
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "bison" => :build # jq depends on bison > 2.5

  def install
    system "autoreconf", "-iv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}/jq .bar", '{"foo":1, "bar":2}')
  end
end

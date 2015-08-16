class Jq < Formula
  desc "Lightweight and flexible command-line JSON processor"
  homepage "https://stedolan.github.io/jq/"
  url "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-1.5.tar.gz"
  sha256 "c4d2bfec6436341113419debf479d833692cc5cdab7eb0326b5a4d4fbe9f493c"

  bottle do
    cellar :any
    sha1 "da645f599da344172de00d756cf6a8ddea86aab5" => :yosemite
    sha1 "29a8f7971976a860dadf00b5d5660f7887b50df5" => :mavericks
    sha1 "4c33838662ed6f806ac21db87d433c8722f488a4" => :mountain_lion
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

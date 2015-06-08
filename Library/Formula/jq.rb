class Jq < Formula
  desc "Lightweight and flexible command-line JSON processor"
  homepage "https://stedolan.github.io/jq/"
  url "http://stedolan.github.io/jq/download/source/jq-1.4.tar.gz"
  sha1 "71da3840839ec74ae65241e182ccd46f6251c43e"

  bottle do
    cellar :any
    sha1 "da645f599da344172de00d756cf6a8ddea86aab5" => :yosemite
    sha1 "29a8f7971976a860dadf00b5d5660f7887b50df5" => :mavericks
    sha1 "4c33838662ed6f806ac21db87d433c8722f488a4" => :mountain_lion
  end

  depends_on "bison" => :build # jq depends on bison > 2.5

  head do
    url "https://github.com/stedolan/jq.git"

    depends_on "oniguruma"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}/jq .bar", '{"foo":1, "bar":2}')
  end
end

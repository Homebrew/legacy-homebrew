class Jq < Formula
  desc "Lightweight and flexible command-line JSON processor"
  homepage "https://stedolan.github.io/jq/"
  url "https://stedolan.github.io/jq/download/source/jq-1.4.tar.gz"
  sha256 "998c41babeb57b4304e65b4eb73094279b3ab1e63801b6b4bddd487ce009b39d"

  bottle do
    cellar :any
    sha1 "da645f599da344172de00d756cf6a8ddea86aab5" => :yosemite
    sha1 "29a8f7971976a860dadf00b5d5660f7887b50df5" => :mavericks
    sha1 "4c33838662ed6f806ac21db87d433c8722f488a4" => :mountain_lion
  end

  devel do
    url "https://github.com/stedolan/jq/archive/jq-1.5rc1.tar.gz"
    sha256 "fea2ac70143b93add57b8df9596247f6c3cbf50553d7eaaef32fa73490a402dc"
  end
  head do
    url "https://github.com/stedolan/jq.git"
  end

  if build.devel? || build.head?
    depends_on "oniguruma"  # jq depends > 1.5
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end
  depends_on "bison" => :build # jq depends on bison > 2.5

  def install
    system "autoreconf", "-iv" if build.devel? || build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}/jq .bar", '{"foo":1, "bar":2}')
  end
end

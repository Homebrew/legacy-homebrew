class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v3.1.2/mlr-3.1.2.tar.gz"
  sha256 "be6f60aac93acb9cb59cfdc3467e8ad4d2ca0383b2e923f4889dd7c38ee3e172"

  bottle do
    cellar :any_skip_relocation
    sha256 "a54793c8b81dd84729e250627993f30688caaa31c646c3ef7d7ec6930cd25921" => :el_capitan
    sha256 "0471239a03728a5c8b7c44fa8b08dec71d87e44a4bb41589a0a06426a0eab93e" => :yosemite
    sha256 "410ac1af4f729b65fd3ccc5049e20fa96a3382d41eaae370f1f0a7730b945b94" => :mavericks
  end

  head do
    url "https://github.com/johnkerl/miller.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-silent-rules",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.csv").write <<-EOS.undent
      a,b,c
      1,2,3
      4,5,6
    EOS
    output = pipe_output("#{bin}/mlr --csvlite cut -f a test.csv")
    assert_match /a\n1\n4\n/, output
  end
end

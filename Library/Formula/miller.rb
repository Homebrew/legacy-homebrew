class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v3.1.2/mlr-3.1.2.tar.gz"
  sha256 "be6f60aac93acb9cb59cfdc3467e8ad4d2ca0383b2e923f4889dd7c38ee3e172"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba7cbfae6c6078e692336fefbdfbcfd1fce93c07470e59911c3cfdfa1baa3aa0" => :el_capitan
    sha256 "4955fd61714aa7f5dfd34ac9a55b39ee7f88efba41d4de829fd86fa76538b672" => :yosemite
    sha256 "740baa43384c675fca9b2882f47506557ffd5c6943952cb3516562a01d44b7a6" => :mavericks
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

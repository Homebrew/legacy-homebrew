class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v3.2.2/mlr-3.2.2.tar.gz"
  sha256 "bf0696152563a7b388c78a8ac6da2e4049846c5527f1d19a720169c086ae9314"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5334cbe74eaf8bc081ba7ee73844d11402b92f800a7ee72dc62f161c7b9282d" => :el_capitan
    sha256 "80c67422825152a971c46fbf1dee7e1f79ca432e16ae0c356693e28f5ef05477" => :yosemite
    sha256 "aa59ba980bb434fddd09f1d7cede77bde3faa03f9349c9bb52b3a23f52308e3a" => :mavericks
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

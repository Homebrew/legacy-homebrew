class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v3.4.0/mlr-3.4.0.tar.gz"
  sha256 "8320285ed55fe401820fdc74ad820d76381c5a8f67980f24e03a4e07ad3f5698"

  bottle do
    cellar :any_skip_relocation
    sha256 "426ad60626f6fbb8ad1e397c6d0838cbf55f9204b460db973e5028f4df5874d4" => :el_capitan
    sha256 "1383f18382bcbb23fabf6357ccf1e0a860cd523edbc93a547a98d06e8213dd3e" => :yosemite
    sha256 "b0a43ea5cb95577c8cc7ee8d4c81f2006926d60382dc151fad5b043050794bfb" => :mavericks
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

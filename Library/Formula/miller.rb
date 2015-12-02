class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v3.0.1/mlr-3.0.1.tar.gz"
  sha256 "35c57a2a28e60046d90360187cffcfd83e96ad61e844e213c2a7f36938f27a5d"

  bottle do
    cellar :any_skip_relocation
    sha256 "9979604237df27df232b8befcafca0f2db939534c5f4af162d242820b8f0de28" => :el_capitan
    sha256 "152bb7c9c61025c358c2924b70490c0ec3de22b7d9206417cf95501469cf9026" => :yosemite
    sha256 "46113c244d8cd0ffc039f8ef94859cda2910d1835266be1356490979d2dfca88" => :mavericks
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

class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v3.4.0/mlr-3.4.0.tar.gz"
  sha256 "8320285ed55fe401820fdc74ad820d76381c5a8f67980f24e03a4e07ad3f5698"

  bottle do
    cellar :any_skip_relocation
    sha256 "423dd1b31e402c9140f8be787368bfdf3b540b336291bb691654c6f5ca762f64" => :el_capitan
    sha256 "d60574a4c152ce731c6639c1e82cbed7fae473b33bf993cecfbe9c55b9d5d88d" => :yosemite
    sha256 "4e6114a1ad605e83509888c954b5fad47ccece4f6674768a843350e740a89a16" => :mavericks
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

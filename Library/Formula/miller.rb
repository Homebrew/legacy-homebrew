class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v2.2.1/mlr-2.2.1.tar.gz"
  sha256 "2e85b0a2beb295174a4346f98dec79573394064c1fc2f004fe6816feefb0ddbe"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e1b2c519a67058ca7ac1a5a8c22f583e86d56c4eb301d2f91d79dda3dc0512e" => :el_capitan
    sha256 "7cf8a45207cbcbe74b0b98360eeaf72f99040c05f27b4e34cd4b5c6323bf649f" => :yosemite
    sha256 "f056fc498efe445e10c0e18bc90f442f4992a93342149fa0a57b9fdfd7af1e80" => :mavericks
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

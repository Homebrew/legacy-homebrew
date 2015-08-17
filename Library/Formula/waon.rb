class Waon < Formula
  desc "Wave-to-notes transcriber"
  homepage "https://kichiki.github.io/WaoN/"
  url "https://github.com/kichiki/WaoN/archive/v0.11.tar.gz"
  sha256 "75d5c1721632afee55a54bcbba1a444e53b03f4224b03da29317e98aa223c30b"

  bottle do
    cellar :any
    sha256 "a16c4df918f59a71396d7c4a5806bafe4bda4a89d3aeb2a52d8dfd41ce6c0432" => :yosemite
    sha256 "7469ec9aa8f549c1294ddb362f8ec2473466c5b027007f3c14fb49984353d813" => :mavericks
    sha256 "bccba5b437852618f1d67fb521dfc2684bb4d70461c61966e97cdd286be40842" => :mountain_lion
  end

  depends_on "fftw"
  depends_on "libsndfile"
  depends_on "pkg-config" => :build

  def install
    system "make", "-f", "Makefile.waon", "waon"
    bin.install "waon"
    man1.install "waon.1"
  end

  test do
    system "say", "check one two", "-o", testpath/"test.aiff"
    system "#{bin}/waon", "-i", testpath/"test.aiff", "-o", testpath/"output.midi"
    assert (testpath/"output.midi").exist?
  end
end

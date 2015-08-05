class Waon < Formula
  desc "Wave-to-notes transcriber"
  homepage "http://kichiki.github.io/WaoN/"
  url "https://github.com/kichiki/WaoN/archive/0a45b687add1cdbfdefc993554053a2153934e44.tar.gz"
  version "2013-03-03"
  sha256 "9e585a4ab38917599e4c376f21e9049c7c94e98892459b61efda866267f6376b"

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

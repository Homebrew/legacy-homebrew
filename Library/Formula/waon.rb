require "formula"

class Waon < Formula
  homepage "http://waon.sourceforge.net"
  url "https://downloads.sourceforge.net/project/waon/waon/0.10/waon-0.10.tar.gz"
  sha1 "392c97e6b210de46ca67e3f23ddeeb2f18ee312f"

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

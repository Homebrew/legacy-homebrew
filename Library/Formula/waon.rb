class Waon < Formula
  desc "Wave-to-notes transcriber"
  homepage "http://waon.sourceforge.net"
  url "https://downloads.sourceforge.net/project/waon/waon/0.10/waon-0.10.tar.gz"
  sha256 "e0a3ba2988351dd40fd60c14b69fa4139eb3ea207711fef365f37d0069d5d4cd"

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

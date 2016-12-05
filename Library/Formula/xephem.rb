class Xephem < Formula
  desc "The Xephem Astronomy Package"
  homepage "http://www.clearskyinstitute.com/xephem/index.html"
  url "http://97.74.56.125/free/xephem-3.7.7.tar.gz"
  sha256 "d1f8e17cfc5d2e3af5fd5a8bcf34bbf99a79d40f66326c098a819f82af62b4b7"

  depends_on :x11

  def install
    cd "GUI/xephem"
    system "make", "MOTIF=../../libXm/osx"
    bin.install "xephem"
    man.mkpath
    man1.install "xephem.1"
  end

  test do
    system "#{bin}/xephem", "-help"
  end
end

class OneMl < Formula
  desc "Reboot of ML, unifying its core and (now first-class) module layers"
  homepage "https://www.mpi-sws.org/~rossberg/1ml/"
  url "https://www.mpi-sws.org/~rossberg/1ml/1ml-0.1.zip"
  sha256 "64c40c497f48355811fc198a2f515d46c1bb5031957b87f6a297822b07bb9c9a"
  revision 1

  bottle do
    cellar :any
    sha256 "cc73f66afbba3987c55fcf9f1f285c8597c81390dcead47a65023e6d44aa6b02" => :yosemite
    sha256 "8697e17bf008608f3f81b8b561ec8ed82e3cdf9b06850a88c213b06f87b2abba" => :mavericks
    sha256 "d9cc9f66611ddf1d255a3090886d84f76ecd90c82fc1b6833a9c736f372dc484" => :mountain_lion
  end

  depends_on "ocaml" => :build

  def install
    system "make"
    bin.install "1ml"
    (share/"one-ml/stdlib").install Dir.glob("*.1ml")
    doc.install "README.txt"
  end

  test do
    system "#{bin}/1ml", "#{share}/one-ml/stdlib/prelude.1ml", "#{share}/one-ml/stdlib/paper.1ml"
  end
end

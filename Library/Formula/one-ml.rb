class OneMl < Formula
  homepage "https://www.mpi-sws.org/~rossberg/1ml/"
  url "https://www.mpi-sws.org/~rossberg/1ml/1ml-0.1.zip"
  sha256 "64c40c497f48355811fc198a2f515d46c1bb5031957b87f6a297822b07bb9c9a"

  depends_on "objective-caml" => :build

  def install
    system "make"
    bin.install "1ml"
    (share/"std").install Dir.glob("*.1ml")
    doc.install "README.txt"
  end

  test do
    system "#{bin}/1ml", "#{share}/std/prelude.1ml", "#{share}/std/paper.1ml"
  end
end

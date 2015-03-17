class OneMl < Formula
  homepage "https://www.mpi-sws.org/~rossberg/1ml/"
  url "https://www.mpi-sws.org/~rossberg/1ml/1ml-0.1.zip"
  sha256 "64c40c497f48355811fc198a2f515d46c1bb5031957b87f6a297822b07bb9c9a"

  bottle do
    cellar :any
    sha256 "85f22e9405c247ae477de31759fe4c5a7dacd9cdd98f0c6c4a13aac4cf6bc3c2" => :yosemite
    sha256 "06e36adef37c7f05e7a615609a3fbe5c281187808006dba695ffaf77b132a5ff" => :mavericks
    sha256 "65566030fd29864434eb8a54ae582c85aa850fecbc570dc12d84ff385dd004a6" => :mountain_lion
  end

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

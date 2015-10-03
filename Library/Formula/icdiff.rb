class Icdiff < Formula
  desc "Improved colored diff"
  homepage "https://github.com/jeffkaufman/icdiff"
  url "https://github.com/jeffkaufman/icdiff/archive/release-1.7.3.tar.gz"
  sha256 "5161265f72a7c9c1d2d7b0780a381743ef3d3127944a96786422802a6bc14ca5"

  bottle do
    cellar :any_skip_relocation
    sha256 "59413c9e1ef2ea94efa504c9b9e26b964904e36857d32a2f6f3e148aa092516e" => :el_capitan
    sha256 "8fc01a5d2a039c9d657a868b6d916d01761effa1d3afa1e6f374f4a5ad266d3e" => :yosemite
    sha256 "b8f8e3807628f0f687b6e8cac5b3bd7a9cbfd4d85371ad48d0fcb20288d90d23" => :mavericks
    sha256 "3a47535005ba94fad4e344200e803f036cef1fb8bdb55f82bcbf014064bd58f2" => :mountain_lion
  end

  def install
    bin.install "icdiff", "git-icdiff"
  end

  test do
    (testpath/"file1").write "test1"
    (testpath/"file2").write "test2"
    system "#{bin}/icdiff", "file1", "file2"
    system "git", "init"
    system "#{bin}/git-icdiff"
  end
end

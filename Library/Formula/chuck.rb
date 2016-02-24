class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "http://chuck.cs.princeton.edu/"
  url "http://chuck.cs.princeton.edu/release/files/chuck-1.3.5.2.tgz"
  sha256 "e900b8545ffcb69c6d49354b18c43a9f9b8f789d3ae822f34b408eaee8d3e70b"

  bottle do
    cellar :any_skip_relocation
    sha256 "3babc57b6bd458d31ffdf632d0402e9e2d6c014a217b45b1d0c121ad4916e8e9" => :el_capitan
    sha256 "5a98251b603885026ee3bae389fe35172bd3b69abd8a54d35d457b825bcadfda" => :yosemite
    sha256 "cdaf6db6aa64715c6fa3aee979fa233a9fb9a2ff9d5d17650d0e3cc70290fcb0" => :mavericks
  end

  depends_on :xcode => :build

  def install
    system "make", "-C", "src", "osx"
    bin.install "src/chuck"
    pkgshare.install "examples"
  end

  test do
    assert_match /probe \[success\]/m, shell_output("#{bin}/chuck --probe 2>&1")
  end
end

class Icdiff < Formula
  desc "Improved colored diff"
  homepage "https://github.com/jeffkaufman/icdiff"
  url "https://github.com/jeffkaufman/icdiff/archive/release-1.7.1.tar.gz"
  sha1 "8af0bb43cb15096fcea1a1ab9a7130d4ca35a058"

  bottle do
    cellar :any
    sha1 "6119783a80f264ca23e220443709e928fcf998b6" => :yosemite
    sha1 "5a1b2d11e972d003be88ddec44a0289a2bef4fa3" => :mavericks
    sha1 "d439ece392e2fbaccabfe95408ce5434ec003a13" => :mountain_lion
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

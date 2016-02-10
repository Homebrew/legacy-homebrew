class DiffSoFancy < Formula
  desc "builds on the good-lookin' output of diff-highlight"
  homepage "https://github.com/stevemao/diff-so-fancy"
  url "https://github.com/stevemao/diff-so-fancy/archive/v0.1.2.tar.gz"
  sha256 "fa4ac51368ba6b942c6b346117e5f72cabb00ea3c29f834e3c4ca80972e19502"

  depends_on "gnu-sed"

  def install
    inreplace "diff-so-fancy", "sed", "gsed"
    libexec.install Dir["*"]
    bin.install_symlink libexec/"diff-so-fancy"
  end

  test do
    system bin/"diff-so-fancy"
  end
end

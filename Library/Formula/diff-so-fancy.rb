class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/stevemao/diff-so-fancy"
  url "https://github.com/stevemao/diff-so-fancy/archive/v0.2.0.tar.gz"
  sha256 "9f23732b7f7cde8bbbb019b4e0473d37888a55afe1b9a07ad9c1bce8ccf2334b"

  depends_on "gnu-sed"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"diff-so-fancy"
  end

  test do
    system bin/"diff-so-fancy"
  end
end

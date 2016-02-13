class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://github.com/so-fancy/diff-so-fancy/archive/v0.2.0.tar.gz"
  sha256 ""

  depends_on "gnu-sed"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"diff-so-fancy"
  end

  test do
    system bin/"diff-so-fancy"
  end
end

class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://github.com/so-fancy/diff-so-fancy/archive/v0.2.1.tar.gz"
  sha256 "64d34acda83f88fb2a326cbf1d80de6c99b05a1ef60768afd13460a9a7c27422"

  depends_on "gnu-sed"

  def install
    bin.install "third_party/diff-highlight/diff-highlight"
    bin.install "diff-so-fancy"
  end

  test do
    system bin/"diff-so-fancy"
  end
end

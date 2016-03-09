class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://github.com/so-fancy/diff-so-fancy/archive/v0.6.2.tar.gz"
  sha256 "518376511f78a354c7af4ad5ded78553d6be892b4845716bca35408f61cc9996"

  bottle :unneeded

  def install
    prefix.install Dir["third_party", "libs", "diff-so-fancy"]
    bin.install_symlink prefix/"diff-so-fancy"
  end

  test do
    system bin/"diff-so-fancy"
  end
end

class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://github.com/so-fancy/diff-so-fancy/archive/v0.6.3.tar.gz"
  sha256 "b56213f08e5f1de1b0529d1a9a62024913ad2f12e043f9818f8cfcf00bed55c4"

  bottle :unneeded

  def install
    prefix.install Dir["third_party", "libs", "diff-so-fancy"]
    bin.install_symlink prefix/"diff-so-fancy"
  end

  test do
    system bin/"diff-so-fancy"
  end
end

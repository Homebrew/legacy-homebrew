class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://github.com/so-fancy/diff-so-fancy/archive/v0.5.2.tar.gz"
  sha256 "ef91042af8197396be037f0bd8b5a362b57c82041c19179d6e0ac8a687e7f8b5"

  bottle :unneeded

  def install
    prefix.install Dir["third_party", "libs", "diff-so-fancy"]
    bin.install_symlink prefix/"diff-so-fancy"
  end

  test do
    system bin/"diff-so-fancy"
  end
end

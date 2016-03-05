class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://github.com/so-fancy/diff-so-fancy/archive/v0.6.0.tar.gz"
  sha256 "8fb60792ba989351803ce19e7b20d3d3b1bafb46ddf0458e338ee7644d13169e"

  bottle :unneeded

  def install
    prefix.install Dir["third_party", "libs", "diff-so-fancy"]
    bin.install_symlink prefix/"diff-so-fancy"
  end

  test do
    system bin/"diff-so-fancy"
  end
end

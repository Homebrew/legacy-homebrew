class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://github.com/so-fancy/diff-so-fancy/archive/v0.7.1.tar.gz"
  sha256 "dcf795df0b398f393215d78679f34427e65aa263be3f4016e7e618706b1b4049"

  bottle :unneeded

  def install
    prefix.install Dir["third_party", "libs", "diff-so-fancy"]
    bin.install_symlink prefix/"diff-so-fancy"
  end

  test do
    system bin/"diff-so-fancy"
  end
end

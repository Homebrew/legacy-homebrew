class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://github.com/so-fancy/diff-so-fancy/archive/v0.3.0.tar.gz"
  sha256 "caecbdcdc1f49e863f51605e8fd37ad65d7c0cf45143985c7556cbe1b6188d83"

  bottle :unneeded

  depends_on "gnu-sed"

  def install
    bin.install "third_party/diff-highlight/diff-highlight"
    bin.install "diff-so-fancy"
  end

  test do
    system bin/"diff-so-fancy"
  end
end

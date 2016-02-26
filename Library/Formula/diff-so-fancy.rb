class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://github.com/so-fancy/diff-so-fancy/archive/v0.5.1.tar.gz"
  sha256 "63c264f3a2989446713bd9ad6669fb5d71825c62c5716c2e27dc3803d5b8c7a0"

  bottle :unneeded

  def install
    bin.install "third_party/diff-highlight/diff-highlight"
    bin.install "diff-so-fancy"
  end

  test do
    system bin/"diff-so-fancy"
  end
end

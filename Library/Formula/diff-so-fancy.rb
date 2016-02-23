class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://github.com/so-fancy/diff-so-fancy/archive/v0.4.1.tar.gz"
  sha256 "87a9db0262fadfb0fe94f98cc0dbbfb8d12b28e41115b6a8e69f4cccb6d250d7"

  bottle :unneeded

  def install
    bin.install "third_party/diff-highlight/diff-highlight"
    bin.install "diff-so-fancy"
  end

  test do
    system bin/"diff-so-fancy"
  end
end

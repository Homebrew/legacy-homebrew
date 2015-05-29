class Makemake < Formula
  homepage "https://github.com/Julow/makemake"
  url "https://github.com/Julow/makemake.git", :tag => "1.0-release"
  head "https://github.com/Julow/makemake.git"
  sha256 "47b79f953e39db26d4cdd612572c52e9a06b7899025ef53ed874baa4a7a03b23"
  version "1.0"
  def install
    mv "makemake.py", "makemake"
    bin.install "makemake"
  end
  test do
    system "makemake", "--test"
    system "cat", "Makefile"
  end
end

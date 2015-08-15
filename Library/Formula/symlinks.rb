class Symlinks < Formula
  desc "symbolic link maintenance utility"
  homepage "https://github.com/brandt/symlinks"
  url "https://github.com/brandt/symlinks/archive/v1.4.3.tar.gz"
  head "https://github.com/brandt/symlinks.git"
  version "1.4.3"
  sha256 "27105b2898f28fd53d52cb6fa77da1c1f3b38e6a0fc2a66bf8a25cd546cb30b2"

  def install
    system "make"
    bin.install "symlinks"
    man8.install "symlinks.8"
  end

  test do
    File.symlink (testpath/"nonexistent"), "dangling_link"
    system "#{bin}/symlinks", "-d", testpath
    assert !File.symlink?("dangling_link")
  end
end

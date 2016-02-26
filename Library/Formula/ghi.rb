class Ghi < Formula
  desc "Work on GitHub issues on the command-line"
  homepage "https://github.com/stephencelis/ghi"
  url "https://github.com/stephencelis/ghi/archive/1.1.1.tar.gz"
  sha256 "a19fd947f1268d9f087d2a342964dfc1cb3aa96de970e82b8daf22461e07e49b"
  head "https://github.com/stephencelis/ghi.git"

  bottle :unneeded

  def install
    bin.install "ghi"
    man1.install "man/ghi.1"
  end

  test do
    system "#{bin}/ghi", "--version"
  end
end

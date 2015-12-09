class Ghi < Formula
  desc "Work on GitHub issues on the command-line"
  homepage "https://github.com/stephencelis/ghi"
  url "https://github.com/stephencelis/ghi/archive/1.0.3.tar.gz"
  sha256 "98ddf904bfd78d7363986b75ecea294933c8b98d9c1d2828419fddcaeadc0fdd"
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

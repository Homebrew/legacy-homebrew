class Ghi < Formula
  desc "Work on GitHub issues on the command-line"
  homepage "https://github.com/stephencelis/ghi"
  url "https://github.com/stephencelis/ghi/archive/0.9.4.tar.gz"
  head "https://github.com/stephencelis/ghi.git"
  sha256 "253eb84c28f4135d41e5276c5e0eb5a8723b77fe07f650204458b4776d9872cc"

  def install
    bin.install "ghi"
    man1.install "man/ghi.1"
  end

  test do
    system "#{bin}/ghi", "--version"
  end
end

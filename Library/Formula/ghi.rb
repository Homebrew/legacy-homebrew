class Ghi < Formula
  desc "Work on GitHub issues on the command-line"
  homepage "https://github.com/stephencelis/ghi"
  url "https://github.com/stephencelis/ghi/archive/0.9.3.tar.gz"
  head "https://github.com/stephencelis/ghi.git"
  sha256 "1b58c7ec6e9339c44175808719694d7ee21cbd254d3a2e6d31a70d31027e9bea"

  def install
    bin.install "ghi"
    man1.install "man/ghi.1"
  end

  test do
    system "#{bin}/ghi", "--version"
  end
end

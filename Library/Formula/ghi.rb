class Ghi < Formula
  desc "Work on GitHub issues on the command-line"
  homepage "https://github.com/stephencelis/ghi"
  url "https://github.com/stephencelis/ghi/archive/1.0.0.tar.gz"
  head "https://github.com/stephencelis/ghi.git"
  sha256 "6227c783a4e50288cee0ea7d6f00462881d8dcb144ae6126f3da19ad9119fd3d"

  def install
    bin.install "ghi"
    man1.install "man/ghi.1"
  end

  test do
    system "#{bin}/ghi", "--version"
  end
end

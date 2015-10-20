class Ghi < Formula
  desc "Work on GitHub issues on the command-line"
  homepage "https://github.com/stephencelis/ghi"
  url "https://github.com/stephencelis/ghi/archive/1.0.2.tar.gz"
  head "https://github.com/stephencelis/ghi.git"
  sha256 "7ab047dafb501bfa34e5d5fedd64954ad9c1dbb47faabe2d9789ac8b53796d11"

  def install
    bin.install "ghi"
    man1.install "man/ghi.1"
  end

  test do
    system "#{bin}/ghi", "--version"
  end
end

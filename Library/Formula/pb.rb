class Pb < Formula
  desc "CLI Pastebin.com client"
  homepage "https://github.com/0xCD/pb"
  url "https://github.com/0xCD/pb/archive/1.0.0.tar.gz"
  sha256 "ac56d55319b1d981f5b43ab76867af0d1c7d53643f690a60adda288b53125414"
  head "https://github.com/0xCD/pb"

  bottle :unneeded

  def install
    bin.install "pb"
  end

  test do
    system "#{bin}/pb"
  end
end

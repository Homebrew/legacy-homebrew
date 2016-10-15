class Img2xterm < Formula
  desc "Display images on terminal"
  homepage "https://github.com/kfei/img2xterm"
  head "https://github.com/kfei/img2xterm.git"
  url "https://github.com/kfei/img2xterm/archive/master.tar.gz"
  sha256 "f91a21b31679b399a1270e9bfbc55e804b5b76399f0a23ff4460312390dca812"
  version "1.0"

  depends_on "pkg-config" => :build
  depends_on 'imagemagick'

  def install
    system "make", "all"
    bin.install "img2xterm"
  end
end

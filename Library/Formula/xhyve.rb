class Xhyve < Formula
  desc "xhyve, a lightweight OS X virtualization solution"
  homepage "http://www.pagetable.com/?p=831"
  url "https://github.com/mist64/xhyve/archive/v0.1.0.tar.gz"
  sha256 "75be0cf1ab345874aef00833e34cf337e71aad0f946d7f9bf8ade248fc4f6b59"
  head "https://github.com/mist64/xhyve.git"

  bottle do
    cellar :any
    sha256 "cfbc2e2bf6b8e2fe8892779c9e6dadedab2f0cedfb63aa648bc26febd0c1257a" => :yosemite
  end

  depends_on :macos => :yosemite

  def install
    system "make"
    bin.install "build/xhyve"
  end

  test do
    system "#{bin}/xhyve", "-h"
  end
end

class Xhyve < Formula
  desc "xhyve is a port of bhyve to OS X"
  homepage "https://github.com/mist64/xhyve"
  url "https://github.com/mist64/xhyve/archive/v0.1.0.tar.gz"
  sha256 "75be0cf1ab345874aef00833e34cf337e71aad0f946d7f9bf8ade248fc4f6b59"

  head "https://github.com/mist64/xhyve.git"

  depends_on MinimumMacOSRequirement => :yosemite

  def install
    system "make"
    bin.install "build/xhyve"
  end

  test do
    system "xhyve", "-h"
  end
end

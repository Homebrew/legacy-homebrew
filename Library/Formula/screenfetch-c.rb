require "formula"

class ScreenfetchC < Formula
  homepage "http://woodruffw.us/realsite/projects/screenfetch-c.html"
  url "https://github.com/woodruffw/screenfetch-c/archive/1.2-fix2.tar.gz"
  sha1 "0eee57ecd156ae818efce48f3ca80e706050a8c6"
  version "1.2"

  def install
    system "make", "osx"
    bin.install "screenfetch-c", "src/detectde", "src/detectwm", "src/detectwmtheme", "src/detectgtk", "src/detectgpu"
    man1.install "manpage/screenfetch-c.1"
  end
end

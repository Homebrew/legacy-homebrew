require "formula"

class Screenfetch < Formula
  homepage "https://github.com/KittyKatt/screenFetch"
  url "https://github.com/KittyKatt/screenFetch/archive/v3.6.5.tar.gz"
  sha1 "b409cf4c66fe5cdd8ee9ecfa85d1234a76a63588"
  head "git://git.silverirc.com/screenfetch.git", :shallow => false

  bottle do
    cellar :any
    sha1 "2a0024cef77d8b77c6ac4f7a05d4c40b0560547c" => :yosemite
    sha1 "982ec8491a1ec97ab57063120a3cc95f021c9ae7" => :mavericks
    sha1 "3a1213b42c9f45cc8ed6c8f4194c4777adbbbeb3" => :mountain_lion
  end

  def install
    bin.install "screenfetch-dev" => "screenfetch"
    man1.install "screenfetch.1"
  end

  test do
    system "#{bin}/screenfetch"
  end
end

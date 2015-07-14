require "formula"

class Screenfetch < Formula
  desc "Generate ASCII art with terminal, shell, and OS info"
  homepage "https://github.com/KittyKatt/screenFetch"
  url "https://github.com/KittyKatt/screenFetch/archive/3.7.0.tar.gz"
  sha256 "6711fe924833919d53c1dfbbb43f3777d33e20357a1b1536c4472f6a1b3c6be0"
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

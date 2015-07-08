class Screenfetch < Formula
  desc "Generate ASCII art with terminal, shell, and OS info"
  homepage "https://github.com/KittyKatt/screenFetch"
  url "https://github.com/KittyKatt/screenFetch/archive/v3.6.5.tar.gz"
  sha256 "b6605a94be9720a5e64778dcc43ddf23e435d6704c5d177b671aa57d34966f20"
  head "https://github.com/KittyKatt/screenFetch.git"

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

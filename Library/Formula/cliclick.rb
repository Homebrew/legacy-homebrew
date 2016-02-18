class Cliclick < Formula
  desc "Tool for emulating mouse and keyboard events"
  homepage "https://www.bluem.net/jump/cliclick/"
  url "https://github.com/BlueM/cliclick/archive/3.2.tar.gz"
  sha256 "11245e06030a1603200d56ef5cbb3b0ee182ca6fe11f1d88504b137d7ecc0d8a"

  bottle do
    cellar :any_skip_relocation
    sha256 "77a5c1b6670bd5d97d368ef1be82529f037476384a6728ddb17c16bb6d391e68" => :el_capitan
    sha256 "720387cff546148dce05fdd3272e0643b918b7767c8e8606e849bc46057c9ff5" => :yosemite
    sha256 "3de7b6cb16479169db7b7dd905f41f7845665cf347d7328a1b9138f8cf0a2fc5" => :mavericks
  end

  def install
    system "make"
    bin.install "cliclick"
  end

  test do
    system bin/"cliclick", "p:OK"
  end
end

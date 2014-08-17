require "formula"

class Rainbarf < Formula
  homepage "https://github.com/creaktive/rainbarf"
  url "https://github.com/creaktive/rainbarf/archive/v1.2.tar.gz"
  sha1 "684f46427cc9f36ffee6ae29e51f88f6dfc26760"

  def install
    system "pod2man", "rainbarf", "rainbarf.1"
    man1.install "rainbarf.1"
    bin.install "rainbarf"
  end

  test do
    system "#{bin}/rainbarf"
  end
end

require "formula"

class Screenfetch < Formula
  homepage "http://git.silverirc.com/cgit.cgi/screenfetch.git"
  url "http://git.silverirc.com/cgit.cgi/screenfetch.git/snapshot/screenfetch-3.2.2.tar.gz"
  sha1 "a520cfcc58cb4c63055dafb7d1df62a967496537"

  def install
    system "mv screenfetch-dev screenfetch"
    bin.install "screenfetch"
  end

  test do
    system "#{bin}/screenfetch"
  end
end

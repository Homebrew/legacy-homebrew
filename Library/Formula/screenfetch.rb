require "formula"

class Screenfetch < Formula
  homepage "http://git.silverirc.com/cgit.cgi/screenfetch.git"
  url "http://git.silverirc.com/cgit.cgi/screenfetch.git/snapshot/screenfetch-3.2.2.tar.bz2"
  sha1 "29ec0d68b2799a946dc75b390d96e5f1b2bb8aaf"

  def install
    bin.install "screenfetch-dev" => "screenfetch"
  end

  test do
    system "#{bin}/screenfetch"
  end
end

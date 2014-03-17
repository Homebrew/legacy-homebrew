require "formula"

class Screenfetch < Formula
  homepage "http://git.silverirc.com/cgit.cgi/screenfetch.git"
  url "http://git.silverirc.com/cgit.cgi/screenfetch.git/snapshot/screenfetch-3.2.2.tar.gz"
  sha1 "904b2824246ef5ae93d1ee4cda76b9d74333a27f"

  def install
    system "mv screenfetch-dev screenfetch"
    bin.install "screenfetch"
  end

  test do
    system "#{bin}/screenfetch"
  end
end

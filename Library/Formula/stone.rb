require 'formula'

class Stone < Formula
  homepage 'http://www.gcd.org/sengoku/stone/'
  url 'http://www.gcd.org/sengoku/stone/stone-2.3e.tar.gz'
  version '2.3e'
  sha1 '1ed12f29c1f896c1a94237b30201c615af5bb0f8'

  def install
    system "make", "macosx"
    system "install", "-d", "#{bin}"
    system "install", "stone", "#{bin}"
  end
end

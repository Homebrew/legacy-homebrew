require 'formula'

class Stone < Formula
  homepage 'http://www.gcd.org/sengoku/stone/'
  url 'http://www.gcd.org/sengoku/stone/stone-2.3e.tar.gz'
  sha1 '1ed12f29c1f896c1a94237b30201c615af5bb0f8'

  option 'with-ssl', 'SSL support'

  def install
    target = (build.with? 'ssl') ? "macosx-ssl" : "macosx"
    system "make", target
    bin.install "stone"
  end
end

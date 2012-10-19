require 'formula'

class Sdhash < Formula
  homepage 'http://roussev.net/sdhash/sdhash.html'
  url 'http://roussev.net/sdhash/releases/packages/sdhash-2.3.tar.gz'
  sha1 '711a7d3fdc2bf0d27e034078a4369b8489215654'

  def install
    system 'make', 'boost'
    system 'make', 'stream'
    bin.install 'sdhash'
    man1.install Dir['man/*.1']
  end

  def test
    system "#{bin}/sdhash"
  end
end

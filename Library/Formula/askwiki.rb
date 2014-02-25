require 'formula'

class Askwiki < Formula
  homepage 'https://github.com/bradoyler/askwiki'
  url 'https://github.com/bradoyler/askwiki/archive/0.0.1.tar.gz'
  sha1 '473aa171d98307aa8f1e459f29bc04968bab2206'

  def install
    bin.install "askwiki"
    man1.install "man/askwiki.1"
  end

  test do
    system "#{bin}/askwiki", "--version"
  end
end

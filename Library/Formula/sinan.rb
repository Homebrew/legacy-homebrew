require 'formula'

class Sinan < Formula
  homepage 'https://github.com/erlware/sinan/wiki'
  url 'https://github.com/downloads/erlware/sinan/sinan-4.1.1.tar.gz'
  sha1 '1249d202468b3703029f2f6cf3ec984d85e6729b'

  depends_on 'erlang'

  def install
    bin.install 'sinan'
  end

  def test
    system "#{bin}/sinan"
  end
end

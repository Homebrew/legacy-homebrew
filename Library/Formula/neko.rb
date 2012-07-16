require 'formula'

class Neko < Formula
  url 'http://nekovm.org/_media/neko-1.8.2-osx.tar.gz'
  homepage 'http://nekovm.org/'
  sha1 '692217c08f5d039f0d729c98bf65876aae24891b'

  def install
    bin.install Dir['*.*']
    bin.install %w(neko nekoc nekoml nekotools)
    (include+"neko").install Dir["include/*.h"]
  end
end

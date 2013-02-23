require 'formula'

class CodaCli < Formula
  homepage 'http://justinhileman.info/coda-cli/'
  url 'https://github.com/bobthecow/coda-cli/zipball/v1.0.5'
  sha1 '6ac508f6f75d8e4bb2a984d5d7d1ecb65052317b'

  def install
    bin.install 'coda'
  end
end

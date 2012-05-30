require 'formula'

class CodaCli < Formula
  homepage 'http://justinhileman.info/coda-cli/'
  url 'https://github.com/bobthecow/coda-cli/zipball/v1.0.5'
  md5 'ad5362f24f4cfdd93c7f235467603a5e'

  def install
    bin.install 'coda'
  end
end

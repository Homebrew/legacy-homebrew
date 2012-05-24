require 'formula'

class CodaCli < Formula
  url 'https://github.com/bobthecow/coda-cli/zipball/v1.0.3'
  homepage 'http://justinhileman.info/coda-cli/'
  md5 '706e49cad02472e70b4c361035a852f8'

  def install
    bin.install 'coda'
  end
end

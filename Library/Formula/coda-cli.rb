require 'formula'

class CodaCli < Formula
  homepage 'http://justinhileman.info/coda-cli/'
  url 'https://github.com/bobthecow/coda-cli/zipball/v1.0.3'
  md5 '706e49cad02472e70b4c361035a852f8'

  def install
    bin.install 'coda'
  end
end

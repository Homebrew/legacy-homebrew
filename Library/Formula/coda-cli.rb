require 'formula'

class CodaCli < Formula
  url 'https://github.com/bobthecow/coda-cli/zipball/v1.0.2'
  homepage 'http://justinhileman.info/coda-cli/'
  md5 '1e062ed4c138f082ee625c641f6c33f7'

  def install
    bin.install 'coda'
  end
end

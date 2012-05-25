require 'formula'

class CodaCli < Formula
  homepage 'http://justinhileman.info/coda-cli/'
  url 'https://github.com/bobthecow/coda-cli/zipball/v1.0.4'
  md5 'a86ae7e9f2389406d1a8889ecf5c1566'

  def install
    bin.install 'coda'
  end
end

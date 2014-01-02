require 'formula'

class CodaCli < Formula
  homepage 'http://justinhileman.info/coda-cli/'
  url 'https://github.com/bobthecow/coda-cli/archive/v1.0.5.tar.gz'
  sha1 '60b1b9c1bfe9602f5140dd3ea4b4e6ae2c51acf3'

  def install
    bin.install 'coda'
  end
end

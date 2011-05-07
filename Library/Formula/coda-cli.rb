require 'formula'

class CodaCli < Formula
  url 'git://github.com/bobthecow/coda-cli.git', :tag => 'v1.0.0'
  version '1.0.0'
  head 'git://github.com/bobthecow/coda-cli.git', :branch => 'develop'
  homepage 'http://justinhileman.info/coda-cli/'

  def install
    chmod 0755, 'coda'
    bin.install 'coda'
  end
end

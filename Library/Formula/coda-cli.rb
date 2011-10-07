require 'formula'

class CodaCli < Formula
  url 'https://github.com/bobthecow/coda-cli/zipball/v1.0.0'
  homepage 'http://justinhileman.info/coda-cli/'
  md5 'ae7e53dffcd2a7a01e653429ce4bd5a6'

  def install
    bin.install 'coda'
  end
end

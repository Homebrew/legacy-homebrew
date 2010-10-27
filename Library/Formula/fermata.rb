require 'formula'

class Fermata < Formula
  url 'http://ghsoftware.s3.amazonaws.com/fermata-0.6.1.tar.gz'
  md5 '299f2bf7bd5708fb6eac8c8e3214323b'
  version '0.6.1'
  homepage 'http://github.com/scsibug/fermata'

  def install
    bin.install 'fermata'
    bin.install 'fermata.war'
    prefix.install Dir['*']
  end
end

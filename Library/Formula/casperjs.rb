require 'formula'

class Casperjs < Formula
  homepage 'http://www.casperjs.org/'
  url 'https://github.com/n1k0/casperjs/archive/1.0.2.tar.gz'
  sha1 '977d68d96ca05a656f31e2f2c15f02b11e6aa724'

  head 'https://github.com/n1k0/casperjs.git'

  depends_on 'phantomjs'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec+'bin/casperjs'
  end
end

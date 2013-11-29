require 'formula'

class Casperjs < Formula
  homepage 'http://www.casperjs.org/'
  url 'https://github.com/n1k0/casperjs/archive/1.0.4.tar.gz'
  sha1 '4e1bdbf2ce93506b6c0d193c90a6f9bcd58c6254'

  devel do
    url 'https://github.com/n1k0/casperjs/archive/1.1-beta3.tar.gz'
    sha1 'd1c31f6a19c0b636f3e4dc17ffeb8224c8af8aef'
    version '1.1-beta3'
  end

  head 'https://github.com/n1k0/casperjs.git'

  depends_on 'phantomjs'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec+'bin/casperjs'
  end
end

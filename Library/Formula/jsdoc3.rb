require 'formula'

class Jsdoc3 < Formula
  homepage 'http://usejsdoc.org/'
  url 'https://github.com/jsdoc3/jsdoc/archive/v3.2.1.tar.gz'
  sha1 '9475bdef742dbdee96e002f000a2d99e05253093'

  head 'https://github.com/jsdoc3/jsdoc.git', :branch => 'master'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec/'jsdoc'
  end
end

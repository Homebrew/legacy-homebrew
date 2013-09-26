require 'formula'

class Jsdoc3 < Formula
  homepage 'http://usejsdoc.org/'
  url 'https://github.com/jsdoc3/jsdoc/archive/v3.2.0.tar.gz'
  sha1 'ac682fd15e6863233835c8969be9e4212dc2e4eb'

  head 'https://github.com/jsdoc3/jsdoc.git', :branch => 'master'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec/'jsdoc'
  end
end

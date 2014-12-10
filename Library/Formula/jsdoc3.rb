require 'formula'

class Jsdoc3 < Formula
  homepage 'http://usejsdoc.org/'
  head 'https://github.com/jsdoc3/jsdoc.git'
  url 'https://github.com/jsdoc3/jsdoc/archive/v3.2.2.tar.gz'
  sha1 '69d284a65a9b2b06c6e6454acb30976b41dea7b6'

  conflicts_with 'jsdoc-toolkit', :because => 'both install jsdoc'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec/'jsdoc'
  end
end

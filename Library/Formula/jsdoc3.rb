require 'formula'

class Jsdoc3 < Formula
  homepage 'http://usejsdoc.org/'
  url 'https://github.com/jsdoc3/jsdoc/archive/v3.0.1.tar.gz'
  sha1 '3d13978c93b1f7ad386667879b1def2cc616e94b'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec/'jsdoc'
  end
end

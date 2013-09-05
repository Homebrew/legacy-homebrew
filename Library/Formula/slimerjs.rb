require 'formula'

class Slimerjs < Formula
  homepage 'http://slimerjs.org/'
  url      'http://download.slimerjs.org/v0.8/slimerjs-0.8.2-mac.tar.bz2'
  sha1     '84f5cd45c8aae1cddcb658ac24ebb43ef2cbbe54'

  def install
    prefix.install Dir['*']
    bin.install_symlink prefix + 'slimerjs'
  end
end

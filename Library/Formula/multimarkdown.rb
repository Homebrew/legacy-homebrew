require 'formula'

class Multimarkdown < Formula
  homepage 'http://fletcherpenney.net/multimarkdown/'
  url 'https://github.com/fletcher/peg-multimarkdown/tarball/3.5'
  md5 '3ba5725c96b1c12f5c2419be9753bf80'
  head 'https://github.com/fletcher/peg-multimarkdown.git', :branch => 'development'

  def install
    ENV.append 'CFLAGS', '-include GLibFacade.h'
    system "make"
    bin.install 'multimarkdown'
    bin.install Dir['Support/bin/*']
    bin.install Dir['scripts/*']
  end
end

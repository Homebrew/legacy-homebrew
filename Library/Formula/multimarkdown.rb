require 'formula'

class Multimarkdown < Formula
  homepage 'http://fletcherpenney.net/multimarkdown/'
  url 'https://github.com/fletcher/peg-multimarkdown/tarball/3.5'
  md5 'fa4e93b38f2e1fec37d5a9441daa10a6'
  head 'https://github.com/fletcher/peg-multimarkdown.git', :branch => 'development'

  def install
    ENV.append 'CFLAGS', '-include GLibFacade.h'
    system "make"
    bin.install 'multimarkdown'
    bin.install Dir['Support/bin/*']
    bin.install Dir['scripts/*']
  end
end

require 'formula'

class Multimarkdown < Formula
  homepage 'http://fletcherpenney.net/multimarkdown/'
  url 'https://github.com/fletcher/peg-multimarkdown/tarball/3.2'
  md5 '438a7c09af13adf91e318ba2f49681b6'
  head 'https://github.com/fletcher/peg-multimarkdown.git', :branch => 'development'

  def install
    ENV.append 'CFLAGS', '-include GLibFacade.h'
    system "make"
    bin.install 'multimarkdown'
    bin.install Dir['Support/bin/*']
    bin.install Dir['scripts/*']
  end
end

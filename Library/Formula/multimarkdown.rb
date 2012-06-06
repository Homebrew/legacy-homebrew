require 'formula'

# url uses git tag to download submodules.
class Multimarkdown < Formula
  homepage 'http://fletcherpenney.net/multimarkdown/'
  url 'https://github.com/fletcher/peg-multimarkdown.git', :tag => '3.6'

  head 'https://github.com/fletcher/peg-multimarkdown.git', :branch => 'development'

  def install
    ENV.append 'CFLAGS', '-include GLibFacade.h'
    system "make"
    bin.install 'multimarkdown'
    bin.install Dir['Support/bin/*']
    bin.install Dir['scripts/*']
  end
end

require 'formula'

class Multimarkdown < Formula
  homepage 'http://fletcherpenney.net/multimarkdown/'

  # Use the tag instead of the tarball to get submodules
  url 'https://github.com/fletcher/peg-multimarkdown.git', :tag => '3.7'
  version '3.7'

  head 'https://github.com/fletcher/peg-multimarkdown.git', :branch => 'development'

  def install
    # Since we want to use our CFLAGS, we need to add the following:
    ENV.append_to_cflags '-include GLibFacade.h'
    ENV.append_to_cflags '-D MD_USE_GET_OPT=1'
    ENV.append_to_cflags '-I..'
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install 'multimarkdown'
    bin.install Dir['scripts/*']
    # The support stuff will be put into the Cellar only
    prefix.install 'Support'
  end

  def caveats; <<-EOS.undent
    Support files have been installed to:
      #{prefix}/Support
    EOS
  end
end

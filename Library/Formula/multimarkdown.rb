require 'formula'

class Multimarkdown < Formula
  homepage 'http://fletcherpenney.net/multimarkdown/'

  # Use the tag instead of the tarball to get submodules
  url 'https://github.com/fletcher/MultiMarkdown-4.git', :tag => '4.1.1'
  version '4.1.1'

  head 'https://github.com/fletcher/MultiMarkdown-4.git', :branch => 'master'

  def install
    # Since we want to use our CFLAGS, we need to add the following:
    # ENV.append_to_cflags '-g -O3 -include GLibFacade.h'
    # system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    ENV.append 'CFLAGS', '-g -O3 -include GLibFacade.h'
    system "make"
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

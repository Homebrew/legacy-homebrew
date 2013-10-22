require 'formula'

class Multimarkdown < Formula
  homepage 'http://fletcherpenney.net/multimarkdown/'

  # Use the tag instead of the tarball to get submodules
  url 'https://github.com/fletcher/MultiMarkdown-4.git', :tag => '4.3.1'

  head 'https://github.com/fletcher/MultiMarkdown-4.git', :branch => 'master'

  def install
    ENV.append 'CFLAGS', '-g -O3 -include GLibFacade.h'
    system "make"
    bin.install 'multimarkdown'
    bin.install Dir['scripts/*']
    prefix.install 'Support'
  end

  def caveats; <<-EOS.undent
    Support files have been installed to:
      #{prefix}/Support
    EOS
  end
end

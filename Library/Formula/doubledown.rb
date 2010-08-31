require 'formula'

class Doubledown <Formula
  url 'http://github.com/devstructure/doubledown/tarball/v0.0.1'
  homepage 'http://github.com/devstructure/doubledown'
  md5 'd8701eb0372df068fd94c2351ff1feac'
  head 'git://github.com/devstructure/doubledown.git'

  def install
    bin.install Dir['bin/*']
    man1.install Dir['man/man1/*.1']
  end
end

require 'formula'

class Doubledown <Formula
  url 'https://github.com/devstructure/doubledown/tarball/v0.0.2'
  homepage 'https://github.com/devstructure/doubledown'
  md5 '0f540c6da691769ca1efa305ad18acb6'
  head 'git://github.com/devstructure/doubledown.git'

  def install
    bin.install Dir['bin/*']
    man1.install Dir['man/man1/*.1']
  end
end

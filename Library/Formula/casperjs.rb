require 'formula'

class Casperjs < Formula
  homepage 'http://www.casperjs.org/'
  url "https://github.com/n1k0/casperjs/tarball/0.6.10"
  sha1 'eb8155970117fa0748266e7b188030b15d67dcab'

  head 'https://github.com/n1k0/casperjs.git'

  depends_on 'phantomjs'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec+'bin/casperjs'
  end
end

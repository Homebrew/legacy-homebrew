require 'formula'

class Casperjs < Formula
  homepage 'http://www.casperjs.org/'
  url 'https://github.com/n1k0/casperjs/tarball/1.0.0-RC1'
  sha1 '3f08685bf41044a200b78110f5c2062ce1bb918c'

  head 'https://github.com/n1k0/casperjs.git'

  depends_on 'phantomjs'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec+'bin/casperjs'
  end
end

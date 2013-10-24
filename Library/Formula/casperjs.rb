require 'formula'

class Casperjs < Formula
  homepage 'http://www.casperjs.org/'
  url 'https://github.com/n1k0/casperjs/archive/1.0.3.tar.gz'
  sha1 'afbfae02e117ced9edcd26786bcce6baae33bfd9'

  devel do
    url 'https://github.com/n1k0/casperjs/archive/1.1-beta2.tar.gz'
    sha1 'bb45f98c0196b1e6d47bd9969436abd2e888cd96'
    version '1.1-beta2'
  end

  head 'https://github.com/n1k0/casperjs.git'

  depends_on 'phantomjs'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec+'bin/casperjs'
  end
end

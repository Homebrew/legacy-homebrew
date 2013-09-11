require 'formula'

class Casperjs < Formula
  homepage 'http://www.casperjs.org/'
  url 'https://github.com/n1k0/casperjs/archive/1.0.3.tar.gz'
  sha1 'afbfae02e117ced9edcd26786bcce6baae33bfd9'

  devel do
    url 'https://github.com/n1k0/casperjs/archive/1.1-beta1.tar.gz'
    sha1 '9e49094c1123ba2bbf610672443bb69a55a350f2'
    version '1.1-beta1'
  end

  head 'https://github.com/n1k0/casperjs.git'

  depends_on 'phantomjs'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec+'bin/casperjs'
  end
end

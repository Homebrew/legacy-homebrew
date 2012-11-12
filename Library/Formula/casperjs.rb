require 'formula'

class Casperjs < Formula
  homepage 'http://www.casperjs.org/'
  url 'https://github.com/n1k0/casperjs/zipball/1.0.0-RC4'
  sha1 '6211c5014d549e64e7aef751a63f15cc65c2bab6'
  version '1.0.0-RC4'

  head 'https://github.com/n1k0/casperjs.git'

  depends_on 'phantomjs'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec+'bin/casperjs'
  end
end

require 'formula'

class Casperjs < Formula
  homepage 'http://www.casperjs.org/'
  url 'https://github.com/n1k0/casperjs/zipball/1.0.2'
  sha1 '9bfc1f0b0842ebbb1cd28d29897caf3f605e563a'

  head 'https://github.com/n1k0/casperjs.git'

  depends_on 'phantomjs'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec+'bin/casperjs'
  end
end

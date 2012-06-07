require 'formula'

class Casperjs < Formula
  homepage 'http://www.casperjs.org/'
  url "https://github.com/n1k0/casperjs/tarball/0.6.9"
  sha1 '7b4a64432f98092661c687c5cf0ac358beed0625'

  head 'https://github.com/n1k0/casperjs.git'
  
  depends_on 'phantomjs'
  
  def install
    libexec.install Dir['*']
    bin.install_symlink libexec+'bin/casperjs'
  end
  
end

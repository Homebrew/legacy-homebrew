require 'formula'

class Mr < Formula
  homepage 'http://kitenet.net/~joey/code/mr/'
  url 'git://git.kitenet.net/mr', :tag => '1.14'
  version '1.14'

  def install
    system "make"
    bin.install 'mr', 'webcheckout'
    man1.install gzip('mr.1', 'webcheckout.1')
    (share/'mr').install Dir['lib/*']
  end
end

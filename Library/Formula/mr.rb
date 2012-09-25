require 'formula'

class Mr < Formula
  homepage 'http://kitenet.net/~joey/code/mr/'
  url 'git://git.kitenet.net/mr', :tag => '1.13'
  version '1.13'

  def install
    system "make"
    bin.install 'mr', 'webcheckout'
    man1.install gzip('mr.1', 'webcheckout.1')
    (share/'mr').install Dir['lib/*']
  end
end

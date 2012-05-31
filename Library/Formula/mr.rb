require 'formula'

class Mr < Formula
  version '1.02'
  url 'git://git.kitenet.net/mr', :tag => '1.02'
  homepage 'http://kitenet.net/~joey/code/mr/'

  def install
    system "make"
    bin.install ['mr', 'webcheckout']
    man1.install gzip('mr.1', 'webcheckout.1')
    (share+'mr').install Dir['lib/*']
  end
end

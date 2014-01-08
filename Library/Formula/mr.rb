require 'formula'

class Mr < Formula
  homepage 'http://kitenet.net/~joey/code/mr/'
  url 'http://git.kitenet.net/git/mr.git', :tag => '1.20130710'

  def install
    system "make"
    bin.install 'mr', 'webcheckout'
    man1.install gzip('mr.1', 'webcheckout.1')
    (share/'mr').install Dir['lib/*']
  end
end

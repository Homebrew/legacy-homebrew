require 'formula'

class Mr < Formula
  homepage 'http://myrepos.branchable.com/'
  url 'https://github.com/joeyh/myrepos.git', :tag => '1.20141024'

  def install
    system "make"
    bin.install 'mr', 'webcheckout'
    man1.install gzip('mr.1', 'webcheckout.1')
    (share/'mr').install Dir['lib/*']
  end
end

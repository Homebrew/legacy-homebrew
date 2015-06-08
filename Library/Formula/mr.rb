require 'formula'

class Mr < Formula
  desc "Multiple Repository management tool"
  homepage 'http://myrepos.branchable.com/'
  url 'git://myrepos.branchable.com/', :tag => '1.20141024'

  def install
    system "make"
    bin.install 'mr', 'webcheckout'
    man1.install gzip('mr.1', 'webcheckout.1')
    (share/'mr').install Dir['lib/*']
  end
end

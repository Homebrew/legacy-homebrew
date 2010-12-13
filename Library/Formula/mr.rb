require 'formula'

class Mr <Formula
  version '0.50'
  url 'git://git.kitenet.net/mr', :tag => '0.50'
  homepage 'http://kitenet.net/~joey/code/mr/'

  def install
    system "make"
    bin.install ['mr', 'webcheckout']
    man1.install gzip('mr.1', 'webcheckout.1')
    (share+'mr').install Dir['lib/*']
  end
end

require 'formula'

class Proxytunnel <Formula
  homepage 'http://proxytunnel.sourceforge.net/'
  url 'http://downloads.sourceforge.net/proxytunnel/proxytunnel-1.9.0.tgz'
  md5 'd74472b89c3f3b3b0abf6bd809ae34c2'

  def install
    system "make"
    bin.install "proxytunnel"
    man1.install "proxytunnel.1"
  end
end

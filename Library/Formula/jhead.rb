require 'formula'

class Jhead <Formula
  url 'http://www.sentex.net/~mwandel/jhead/jhead-2.87.tar.gz'
  homepage 'http://www.sentex.net/~mwandel/jhead/'
  md5 '7e5e84bf74800808c171956414228db9'

  def install
    system "make"
    system "chmod +x jhead"
    bin.install "jhead"
  end
end

require 'formula'

class Jhead < Formula
  url 'http://www.sentex.net/~mwandel/jhead/jhead-2.95.tar.gz'
  homepage 'http://www.sentex.net/~mwandel/jhead/'
  sha1 'e66b0a64e034054185da3e6c5e1ac7afb36776f8'

  def install
    system "make"
    bin.install "jhead"
    man1.install 'jhead.1'
    doc.install 'usage.html'
  end
end

require 'formula'

class Jhead < Formula
  homepage 'http://www.sentex.net/~mwandel/jhead/'
  url 'http://www.sentex.net/~mwandel/jhead/jhead-2.97.tar.gz'
  sha1 'ca4965a19d60078a3fe2cfb6d3635a083f958f2e'

  def install
    system "make"
    bin.install "jhead"
    man1.install 'jhead.1'
    doc.install 'usage.html'
  end
end

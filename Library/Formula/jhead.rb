require 'formula'

class Jhead < Formula
  homepage 'http://www.sentex.net/~mwandel/jhead/'
  url 'http://www.sentex.net/~mwandel/jhead/jhead-2.96.tar.gz'
  sha1 '668a515276654247e6fbe7a6193a5e1382a38116'

  def install
    system "make"
    bin.install "jhead"
    man1.install 'jhead.1'
    doc.install 'usage.html'
  end
end

require 'formula'

class Pstree < Formula
  url 'ftp://ftp.thp.uni-duisburg.de/pub/source/pstree-2.33.tar.gz'
  homepage 'http://freshmeat.net/projects/pstree/'
  sha1 '2f29ea2618cb6fd90529a543a94ed89b79db58b8'

  def install
    system "make pstree"
    bin.install "pstree"
  end
end

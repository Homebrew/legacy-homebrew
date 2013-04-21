require 'formula'

class Pstree < Formula
  homepage 'http://freshmeat.net/projects/pstree/'
  url 'ftp://ftp.thp.uni-duisburg.de/pub/source/pstree-2.35.tar.gz'
  sha1 'e0b45290c0df1061581b45ce53b503d6fc6cfdf9'

  def install
    system "make pstree"
    bin.install "pstree"
  end
end

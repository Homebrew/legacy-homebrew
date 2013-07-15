require 'formula'

class Pstree < Formula
  homepage 'http://freshmeat.net/projects/pstree/'
  url 'ftp://ftp.thp.uni-duisburg.de/pub/source/pstree-2.36.tar.gz'
  sha1 '1ca2e08c62d33afd37d78a215095258e77654b3f'

  def install
    system "make pstree"
    bin.install "pstree"
  end
end

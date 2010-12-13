require 'formula'

class Pstree <Formula
  url 'ftp://ftp.thp.uni-duisburg.de/pub/source/pstree-2.32.tar.gz'
  homepage 'http://freshmeat.net/projects/pstree/'
  md5 'ba6e274e06d63910cf9bb8664b932808'

  def install
    system "make pstree"
    bin.install "pstree"
  end
end

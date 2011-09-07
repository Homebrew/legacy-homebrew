require 'formula'

class Pstree < Formula
  url 'ftp://ftp.thp.uni-duisburg.de/pub/source/pstree-2.33.tar.gz'
  homepage 'http://freshmeat.net/projects/pstree/'
  md5 'b0a85caacd85f78bd83700afa86ec2e9'

  def install
    system "make pstree"
    bin.install "pstree"
  end
end

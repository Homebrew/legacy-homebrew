require 'formula'

class Topgit < Formula
  url 'git://repo.or.cz/topgit.git', :tag => '1744aca50f3d7b6b4863523207e5010e112dfb85'
  homepage 'http://repo.or.cz/w/topgit.git'
  version '0.8'

  def install
    system "export prefix=#{prefix} && make install"
  end
end

require 'formula'

class Topgit < Formula
  homepage 'http://repo.or.cz/w/topgit.git'
  url 'git://repo.or.cz/topgit.git', :revision => '1744aca50f3d7b6b4863523207e5010e112dfb85'
  version '0.8'

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end

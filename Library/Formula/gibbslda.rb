require 'formula'

class Gibbslda < Formula
  url 'http://downloads.sourceforge.net/project/gibbslda/GibbsLDA%2B%2B/0.2/GibbsLDA%2B%2B-0.2.tar.gz?r=&ts=1314109304'
  homepage 'http://gibbslda.sourceforge.net/'
  md5 'd87d35be6dc8b37afc515f6237ba2ccb'
  version '0.2'

  def install
    system "make clean"
    system "make all"
    bin.install "src/lda"
  end
end

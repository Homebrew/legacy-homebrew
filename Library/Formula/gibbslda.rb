require 'formula'

class Gibbslda < Formula
  homepage 'http://gibbslda.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/gibbslda/GibbsLDA%2B%2B/0.2/GibbsLDA%2B%2B-0.2.tar.gz'
  sha1 '3264f01ae921b6dcbbe57dd877561271df214cdd'

  def install
    system "make clean"
    system "make all"
    bin.install "src/lda"
  end
end

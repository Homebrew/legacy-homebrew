require 'formula'

class Dhex < Formula
  homepage 'http://www.dettus.net/dhex/'
  url 'http://www.dettus.net/dhex/dhex_0.68.tar.gz'
  sha1 'd23d65a7b330b47f8254f6c1ff25a30c4778440e'

  def install
    system "make"
    bin.install 'dhex'
    man1.install 'dhex.1'
    man5.install Dir['*.5']
  end
end

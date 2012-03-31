require 'formula'

class Ren < Formula
  homepage 'http://pdb.finkproject.org/pdb/package.php/ren'
  url 'http://www.ibiblio.org/pub/Linux/utils/file/ren-1.0.tar.gz'
  md5 '245453453a8bd1c0bf7d03880b97d632'

  def install
    system "make"
    bin.install "ren"
    man1.install "ren.1"
  end

  def test
    system 'ren'
  end

end

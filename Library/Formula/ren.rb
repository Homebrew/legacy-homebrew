require 'formula'

class Ren < Formula
  homepage 'http://pdb.finkproject.org/pdb/package.php/ren'
  url 'http://www.ibiblio.org/pub/Linux/utils/file/ren-1.0.tar.gz'
  md5 '245453453a8bd1c0bf7d03880b97d632'

  def install
    system "make"
    system "install -d -m 0755 #{prefix}/bin #{prefix}/share/man/man1"
    system "install -m 0755 ren #{prefix}/bin"
    system "install -m 0644 ren.1 #{prefix}/share/man/man1"
  end

  def test
    system 'ren'
  end

end

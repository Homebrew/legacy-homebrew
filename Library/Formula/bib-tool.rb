require 'formula'

class BibTool < Formula
  url 'http://sarovar.org/frs/download.php/1298/BibTool-2.51.tar.gz'
  homepage 'http://www.gerd-neugebauer.de/software/TeX/BibTool/index.en.html'
  version '2.51'
  md5 '0404647e6d1b2d4c2a34a6d1f4f9e375'

  def install
    system "./configure", "--prefix", prefix
    system "make"
    system "make install"
  end
end

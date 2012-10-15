require 'formula'

class BibTool < Formula
  url 'http://sarovar.org/frs/download.php/1298/BibTool-2.51.tar.gz'
  homepage 'http://www.gerd-neugebauer.de/software/TeX/BibTool/index.en.html'
  sha1 '8cb4f562f4d3d380a809eb1bdbbc9d47d498957e'

  def install
    system "./configure", "--prefix", prefix
    system "make"
    system "make install"
  end
end

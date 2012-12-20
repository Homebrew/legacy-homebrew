require 'formula'

class BibTool < Formula
  homepage 'http://www.gerd-neugebauer.de/software/TeX/BibTool/index.en.html'
  url 'http://www.gerd-neugebauer.de/software/TeX/BibTool/BibTool-2.55.tar.gz'
  sha1 'b36eee9929419a4d0a6d407adc60dbe0ffa9fce9'

  depends_on :automake
  depends_on :libtool

  def install
    # Needd to pick up the --without-kpathsea argument
    system "autoreconf", "-fi"
    system "./configure", "--prefix=#{prefix}", "--without-kpathsea"
    system "make"
    system "make install"
  end
end

require 'formula'

class BibTool < Formula
  homepage 'http://www.gerd-neugebauer.de/software/TeX/BibTool/index.en.html'
  url 'http://www.gerd-neugebauer.de/software/TeX/BibTool/BibTool-2.57.tar.gz'
  sha1 'a6e80c86d347a39f3883e552db2dd4deb72b0e86'

  def install
    system "./configure", "--prefix=#{prefix}", "--without-kpathsea"
    system "make"
    system "make install"
  end
end

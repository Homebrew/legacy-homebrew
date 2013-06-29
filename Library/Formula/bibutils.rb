require 'formula'

class Bibutils < Formula
  homepage 'http://sourceforge.net/p/bibutils/home/Bibutils/'
  url 'http://sourceforge.net/projects/bibutils/files/bibutils_5.0_src.tgz'
  sha1 'cf9b6d7e4d0a679f734e9c477798219dc016a3da'

  def install
    system "./configure", "--install-dir", prefix
    system "make", "CC=#{ENV.cc}"

    cd 'bin' do
      bin.install %w{bib2xml ris2xml end2xml endx2xml med2xml isi2xml copac2xml
        biblatex2xml ebi2xml wordbib2xml xml2ads xml2bib xml2end xml2isi xml2ris
        xml2wordbib modsclean}
    end
  end
end

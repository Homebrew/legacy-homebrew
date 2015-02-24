require "formula"

class Bibutils < Formula
  homepage "http://sourceforge.net/p/bibutils/home/Bibutils/"
  url "https://downloads.sourceforge.net/project/bibutils/bibutils_5.5_src.tgz"
  sha1 "f7cb7a8bd62ac3b5f0caf63a4a6a793355a417f2"

  def install
    system "./configure", "--install-dir", prefix
    system "make", "CC=#{ENV.cc}"

    cd "bin" do
      bin.install %w{bib2xml ris2xml end2xml endx2xml med2xml isi2xml copac2xml
        biblatex2xml ebi2xml wordbib2xml xml2ads xml2bib xml2end xml2isi xml2ris
        xml2wordbib modsclean}
    end
  end
end

require 'formula'

class Velvet < Formula
  url 'http://www.ebi.ac.uk/~zerbino/velvet/velvet_1.1.05.tgz'
  homepage 'http://www.ebi.ac.uk/~zerbino/velvet/'
  md5 'a208b8940550269ebf8d50fddaf9ce47'


  def install
    # Per author recomendation when compiling on Mac
    inreplace "Makefile", "# CFLAGS = -Wall -m64", "CFLAGS = -Wall -m64"

    # Because it needs pdflatex tool
    inreplace "Makefile", "default : cleanobj zlib obj velveth velvetg doc", "default : cleanobj zlib obj velveth velvetg"

    system "make"
    bin.install %w{velvetg velveth}
    (share+'velvet').install %w{shuffleSequences_fasta.pl shuffleSequences_fastq.pl Manual.pdf}
  end
end

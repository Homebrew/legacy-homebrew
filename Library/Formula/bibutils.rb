require 'formula'

class Bibutils <Formula
  url 'http://www.scripps.edu/~cdputnam/software/bibutils/bibutils_4.9_src.tgz'
  homepage 'http://www.scripps.edu/~cdputnam/software/bibutils/'
  md5 '1cc0724b821ae9749b91a267207105dc'

  def install
    system "./configure --install-dir #{prefix}"
    inreplace "Makefile" do |s|
      s.change_make_var! "CC", "CC=\"#{ENV.cc}\""
    end
    system "make"

    executables = %w{ bib2xml ris2xml end2xml endx2xml med2xml isi2xml copac2xml
        biblatex2xml ebi2xml wordbib2xml xml2ads xml2bib xml2end xml2isi
        xml2ris xml2wordbib modsclean }
    executables.each { |x| bin.install "bin/#{x}" }
  end
end

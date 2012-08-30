class PdfLatexRequirement < Requirement
  def message; <<-EOS.undent
    pdfjam requires pdflatex to run. You can install this using MacTex:
      http://tug.org/mactex/
    EOS
  end

  def satisfied?
    which 'pdflatex'
  end

  def fatal?
    true
  end
end

require 'formula'

class Pdfjam < Formula
  url 'http://www2.warwick.ac.uk/fac/sci/statistics/staff/academic-research/firth/software/pdfjam/pdfjam_208.tgz'
  homepage 'http://www2.warwick.ac.uk/fac/sci/statistics/staff/academic-research/firth/software/pdfjam'
  md5 '7df075df7f129091f826275ce8c1f374'
  version '2.08'

  depends_on PdfLatexRequirement.new

  def install
    bin.install Dir['bin/*']
    man.install 'man1'
  end
end

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
  sha1 '981b504ef96369a203f85fefb42d4ea0d1194493'
  version '2.08'

  depends_on PdfLatexRequirement.new

  def install
    bin.install Dir['bin/*']
    man.install 'man1'
  end
end

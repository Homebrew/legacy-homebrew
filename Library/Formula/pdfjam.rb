require 'formula'

class Pdfjam < Formula
  url 'http://www2.warwick.ac.uk/fac/sci/statistics/staff/academic-research/firth/software/pdfjam/pdfjam_208.tgz'
  homepage 'http://www2.warwick.ac.uk/fac/sci/statistics/staff/academic-research/firth/software/pdfjam'
  md5 '7df075df7f129091f826275ce8c1f374'
  version '2.08'

  def install
    bin.install Dir['bin/*']
    man.install 'man1'
  end
end

require 'formula'

class Pdfjam <Formula
  url 'http://www2.warwick.ac.uk/fac/sci/statistics/staff/academic/firth/software/pdfjam/pdfjam_206.tgz'
  homepage 'http://www2.warwick.ac.uk/fac/sci/statistics/staff/academic/firth/software/pdfjam'
  md5 '8113cae5d43359708be9e7e9d6df999d'

  def install
    bin.install Dir['bin/*']
    man.install 'man1'
  end
end

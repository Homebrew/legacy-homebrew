require 'formula'

class Pdfjam < Formula
  homepage 'http://www2.warwick.ac.uk/fac/sci/statistics/staff/academic-research/firth/software/pdfjam'
  url 'http://www2.warwick.ac.uk/fac/sci/statistics/staff/academic-research/firth/software/pdfjam/pdfjam_208.tgz'
  sha1 '981b504ef96369a203f85fefb42d4ea0d1194493'
  version '2.08'

  depends_on :tex

  def install
    bin.install Dir['bin/*']
    man.install 'man1'
  end
end

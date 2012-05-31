require 'formula'

# Notes:
#   man pages won't be installed since:
#     "Neither xsltproc nor xmlto found, documentation cannot be built."
#
#   Some build flags had to be changed in order to have a successfull install
#
#   Python binding as been disabled
#
class Gpsd < Formula
  url 'http://git.savannah.gnu.org/cgit/gpsd.git/snapshot/release-3.5.tar.gz'
  homepage 'https://savannah.nongnu.org/projects/gpsd'
  md5 'a3f88b41c36ee2f2bce6d9ca961688fa'
  version '3.5'

  depends_on 'scons' => :build

  def install
    system "scons", "chrpath=False", "python=False", "strip=False", "shared=False", "prefix=#{prefix}/"
    system "scons install"
  end

  def test
    system "scons testregress"
  end
end

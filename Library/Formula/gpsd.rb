require 'formula'

class Gpsd < Formula
  url 'http://git.savannah.gnu.org/cgit/gpsd.git/snapshot/release-3.5.tar.gz'
  homepage 'https://savannah.nongnu.org/projects/gpsd'
  md5 'a3f88b41c36ee2f2bce6d9ca961688fa'

  depends_on 'scons' => :build

  def install
    system "scons", "chrpath=False", "python=False", "strip=False", "shared=False", "prefix=#{prefix}/"
    system "scons install"
  end
end

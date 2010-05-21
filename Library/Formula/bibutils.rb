require 'formula'

class Bibutils <Formula
  url 'http://www.scripps.edu/~cdputnam/software/bibutils/bibutils_4.8_osx_intel.tgz'
  homepage 'http://www.scripps.edu/~cdputnam/software/bibutils/'
  md5 '11a89c76a65b2688271b1726ce4a23a7'
  version '4.8'

  def install
    bin.install Dir["*"]
  end
end

require 'formula'

class NsisSupport < Formula
  url 'http://downloads.sourceforge.net/project/nsis/NSIS%202/2.46/nsis-2.46.zip'
  md5 'd7e43beabc017a7d892a3d6663e988d4'
end

class Makensis < Formula
  url 'http://downloads.sourceforge.net/project/nsis/NSIS%202/2.46/nsis-2.46-src.tar.bz2'
  homepage 'http://nsis.sourceforge.net/'
  md5 '61c2e81739436b06d7cf7bcce1d533ac'

  depends_on 'scons' => :build

  def install
    system "scons makensis"
    bin.install "build/release/makensis/makensis"
    NsisSupport.new.brew { (share+"nsis").install Dir['*'] }
  end
end

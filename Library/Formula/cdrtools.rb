require 'formula'

class Cdrtools < Formula
  url 'ftp://ftp.berlios.de/pub/cdrecord/cdrtools-3.00.tar.gz'
  homepage 'http://cdrecord.berlios.de/private/cdrecord.html'
  md5 'bb21cefefcfbb76cf249120e8978ffdd'

  depends_on 'smake' => :build

  def patches
    "http://fink.cvs.sourceforge.net/viewvc/fink/dists/10.7/stable/main/finkinfo/devel/smake.patch?revision=1.1&content-type=text%2Fplain"
  end

  def install
    system "smake", "INS_BASE=#{prefix}", "INS_RBASE=#{prefix}", "install"
  end
end

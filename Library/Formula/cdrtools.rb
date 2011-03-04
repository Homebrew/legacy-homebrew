require 'formula'

class Cdrtools < Formula
  url 'ftp://ftp.berlios.de/pub/cdrecord/cdrtools-3.00.tar.gz'
  homepage 'http://cdrecord.berlios.de/private/cdrecord.html'
  md5 'bb21cefefcfbb76cf249120e8978ffdd'

  depends_on 'smake' => :build

  def install
    system "smake", "INS_BASE=#{prefix}", "INS_RBASE=#{prefix}", "install"
  end
end

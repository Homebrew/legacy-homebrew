require 'formula'

class Cdrtools < Formula
  url 'ftp://ftp.berlios.de/pub/cdrecord/cdrtools-3.00.tar.gz'
  homepage 'http://cdrecord.berlios.de/private/cdrecord.html'
  sha1 '2cd7d1725e0da2267b7a033cc744295d6e2bc6b9'

  depends_on 'smake' => :build

  def install
    system "smake", "INS_BASE=#{prefix}", "INS_RBASE=#{prefix}", "install"
  end
end

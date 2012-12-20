require 'formula'

class Cdrtools < Formula
  homepage 'http://cdrecord.berlios.de/private/cdrecord.html'
  url 'ftp://ftp.berlios.de/pub/cdrecord/cdrtools-3.00.tar.gz'
  sha1 '2cd7d1725e0da2267b7a033cc744295d6e2bc6b9'

  def install
    system "make", "INS_BASE=#{prefix}", "INS_RBASE=#{prefix}", "install"
  end
end

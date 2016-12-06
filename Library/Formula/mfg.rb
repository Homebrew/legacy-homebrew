require 'formula'

class Mfg < Formula
  homepage 'http://www.inf.uos.de/elmar/projects/mfg/'
  url 'ftp://ftp.inf.uos.de/pub/elmar/mfg/mfg-2.4.tar.gz'
  sha1 'e7ab2e63c06933302c23af638894c84eaaf445e5'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end
end

require 'formula'

class Msmtp <Formula
  url 'http://downloads.sourceforge.net/project/msmtp/msmtp/1.4.19/msmtp-1.4.19.tar.bz2'
  homepage 'http://msmtp.sourceforge.net'
  md5 'f0afdc943bf7c8a3a3bf3fe1a73072c4'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

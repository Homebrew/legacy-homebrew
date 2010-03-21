require 'formula'

class Clamav <Formula
  url 'http://downloads.sourceforge.net/project/clamav/clamav/0.95.3/clamav-0.95.3.tar.gz'
  homepage 'http://www.clamav.net/lang/en/'
  md5 'eaf9fccc3cc3567605a9732313652967'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

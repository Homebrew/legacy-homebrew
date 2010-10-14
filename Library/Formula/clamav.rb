require 'formula'

class Clamav <Formula
  url 'http://downloads.sourceforge.net/project/clamav/clamav/0.96.3/clamav-0.96.3.tar.gz'
  homepage 'http://www.clamav.net/'
  md5 '663274565c4da17abb112ff88895e510'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

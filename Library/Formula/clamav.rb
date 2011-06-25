require 'formula'

class Clamav < Formula
  url 'http://downloads.sourceforge.net/clamav/clamav-0.97.1.tar.gz'
  homepage 'http://www.clamav.net/'
  md5 '4f3fb74ff1098c25eef8e10721478c29'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

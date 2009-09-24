require 'brewkit'

class Iperf <Formula
  @url='http://downloads.sourceforge.net/project/iperf/iperf/2.0.4%20source/iperf-2.0.4.tar.gz'
  @homepage='http://iperf.sourceforge.net/'
  @md5='8c5bc14cc2ea55f18f22afe3c23e3dcb'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

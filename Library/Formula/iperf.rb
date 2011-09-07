require 'formula'

class Iperf < Formula
  url 'http://downloads.sourceforge.net/project/iperf/iperf-2.0.5.tar.gz'
  homepage 'http://iperf.sourceforge.net/'
  md5 '44b5536b67719f4250faed632a3cd016'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

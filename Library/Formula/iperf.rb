require 'formula'

class Iperf < Formula
  url 'http://downloads.sourceforge.net/project/iperf/iperf-2.0.5.tar.gz'
  homepage 'http://iperf.sourceforge.net/'
  sha1 '7302792dcb1bd7aeba032fef6d3dcc310e4d113f'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

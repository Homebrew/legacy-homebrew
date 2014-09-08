require 'formula'

class Iperf < Formula
  homepage 'http://iperf.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/iperf/iperf-2.0.5.tar.gz'
  sha1 '7302792dcb1bd7aeba032fef6d3dcc310e4d113f'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

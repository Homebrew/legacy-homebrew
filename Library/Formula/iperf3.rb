require 'formula'

class Iperf3 < Formula
  url 'http://iperf.googlecode.com/files/iperf-3.0b4.tar.gz'
  homepage 'http://code.google.com/p/iperf/'
  md5 'fde024a200b064b54accd1959f7e642e'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

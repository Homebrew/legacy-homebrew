require 'formula'

class Iperf3 < Formula
  url 'http://iperf.googlecode.com/files/iperf-3.0b4.tar.gz'
  homepage 'http://code.google.com/p/iperf/'
  md5 'fde024a200b064b54accd1959f7e642e'

  def install
    # Make sure Apple's uuid.h is found (if e.g. ossp-uuid is installed).
    ENV.append 'CFLAGS', '-I/usr/include/uuid'

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

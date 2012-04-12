require 'formula'

class Daq < Formula
  url 'http://www.snort.org/dl/snort-current/daq-0.5.tar.gz'
  homepage 'http://www.snort.org/'
  md5 'ea9d8147f39c44ce00dd2d7eb19ce0ea'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

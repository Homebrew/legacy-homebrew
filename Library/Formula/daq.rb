require 'formula'

class Daq < Formula
  homepage 'http://www.snort.org/'
  url 'http://www.snort.org/dl/snort-current/daq-1.1.1.tar.gz'
  sha1 '60d3ccb3fb34a0dfe9f9747a3ade45f130716337'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

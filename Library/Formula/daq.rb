require 'formula'

class Daq < Formula
  homepage 'http://www.snort.org/'
  url 'http://www.snort.org/downloads/snort/daq-2.0.2.tar.gz'
  sha1 'def1a5b28fd16758aeb85a02f3813250014d4d75'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

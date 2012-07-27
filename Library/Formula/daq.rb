require 'formula'

class Daq < Formula
  homepage 'http://www.snort.org/'
  url 'http://www.snort.org/dl/snort-current/daq-1.1.1.tar.gz'
  md5 'bc204ea09165b4ecbb1bb49c7c1a2ad4'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

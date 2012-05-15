require 'formula'

class Daq < Formula
  url 'http://www.snort.org/dl/snort-current/daq-0.6.2.tar.gz'
  homepage 'http://www.snort.org/'
  md5 '6ea8aaa6f067f8b8ef6de45b95d55875'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

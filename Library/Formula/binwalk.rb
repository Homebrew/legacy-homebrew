require 'formula'

class Binwalk < Formula
  url 'http://binwalk.googlecode.com/files/binwalk-0.3.7.tar.gz'
  homepage 'http://code.google.com/p/binwalk/'
  md5 'e37b59e1b347c77ec8104453918e12aa'

  def install
    cd "src"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

require 'formula'

class Binwalk < Formula
  url      'http://binwalk.googlecode.com/files/binwalk-0.4.1.tar.gz'
  homepage 'http://code.google.com/p/binwalk/'
  md5      '95e04f44b4664ba2a7cbe370e1439530'

  depends_on 'libmagic'

  def install
    Dir.chdir "src"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

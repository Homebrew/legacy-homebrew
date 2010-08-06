require 'formula'

class Ncrack <Formula
  url 'http://nmap.org/ncrack/dist/ncrack-0.2ALPHA.tar.gz'
  homepage 'http://nmap.org/ncrack/'
  md5 '611d643b76008d44ca3e9eafad11393e'
  version '0.2ALPHA'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

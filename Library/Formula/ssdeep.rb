require 'formula'

class Ssdeep < Formula
  homepage 'http://ssdeep.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/ssdeep/ssdeep-2.9/ssdeep-2.9.tar.gz'
  sha256 '5270297d315541d188b11047fc26c1d4269ef853a0cabb0d59ee8d9a327bf8aa'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

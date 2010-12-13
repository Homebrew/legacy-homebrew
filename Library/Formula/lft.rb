require 'formula'

class Lft <Formula
  url 'http://pwhois.org/dl/index.who?file=lft-3.1.tar.gz'
  homepage 'http://pwhois.org/lft/'
  md5 '70e69706e7600f34c0dfb54e2ee5eb01'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

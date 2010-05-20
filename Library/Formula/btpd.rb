require 'formula'

class Btpd <Formula
  url 'http://www.murmeldjur.se/btpd/btpd-0.15.tar.gz'
  homepage 'http://www.murmeldjur.se/btpd/'
  md5 'b64e2e8b9936e99685bc1e7246655561'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

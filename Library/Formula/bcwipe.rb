require 'formula'

class Bcwipe < Formula
  homepage 'http://www.jetico.com/linux/bcwipe-help/'
  url 'http://www.jetico.com/linux/BCWipe-1.9-9.tar.gz'
  md5 '1377971bafce72238d1a062e2305c1c0'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}", "install"
  end
end

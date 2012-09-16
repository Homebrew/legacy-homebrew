require 'formula'

class Bcwipe < Formula
  homepage 'http://www.jetico.com/linux/bcwipe-help/'
  url 'http://www.jetico.com/linux/BCWipe-1.9-9.tar.gz'
  sha1 'be4d945a5d24076fb6b0356389323a0686e1e4d7'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}", "install"
  end
end

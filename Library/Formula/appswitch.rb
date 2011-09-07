require 'formula'

class Appswitch < Formula
  url 'http://web.sabi.net/nriley/software/appswitch-1.1.tar.gz'
  homepage 'http://web.sabi.net/nriley/software/'
  md5 '07cf9884a07939da487898cddba0c296'

  def install
    system "#{ENV.cc} -o appswitch #{ENV.cflags} main.c -framework ApplicationServices"
    man1.install gzip('appswitch.1')
    bin.install 'appswitch'
  end
end

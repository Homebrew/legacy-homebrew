require 'formula'

class Connect < Formula
  url 'http://www.meadowy.org/~gotoh/ssh/connect.c'
  version '1.100'
  homepage 'http://bent.latency.net/bent/git/goto-san-connect-1.85/src/connect.html'
  md5 '5165e2fcd2cf58899f34878fe6b447c6'

  def install
    system "#{ENV.cc}", "connect.c", "-o", "connect", "-lresolv"
    bin.install "connect"
  end
end

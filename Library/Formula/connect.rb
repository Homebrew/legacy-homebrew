require 'formula'

class Connect < Formula
  homepage 'http://bent.latency.net/bent/git/goto-san-connect-1.85/src/connect.html'
  url 'http://www.meadowy.org/~gotoh/ssh/connect.c'
  version '1.100'
  sha1 '39614dfa842514f46bdb6ff66a10d2f5b084234f'

  def install
    system "#{ENV.cc}", "connect.c", "-o", "connect", "-lresolv"
    bin.install "connect"
  end
end

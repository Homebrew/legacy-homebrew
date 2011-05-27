require 'formula'

class Ptunnel < Formula
  url 'http://www.cs.uit.no/~daniels/PingTunnel/PingTunnel-0.71.tar.gz'
  version '0.71'
  homepage 'http://www.cs.uit.no/~daniels/PingTunnel/'
  md5 '9b04771d4fa50abc15a6af690b81c71a'

  def install
    system "make"
    bin.install "ptunnel"
    man8.install "ptunnel.8"
  end

  def caveats
    <<-EOS
    Normally, ptunnel uses raw sockets and must be run as root (using sudo, for example).

    Alternatively, you can try using the -u flag to start ptunnel in 'unprivileged' mode,
    but this is not recommended. See http://www.cs.uit.no/~daniels/PingTunnel/ for details.
    EOS
  end
end

require 'formula'

class Ptunnel < Formula
  homepage 'http://www.cs.uit.no/~daniels/PingTunnel/'
  url 'http://www.cs.uit.no/~daniels/PingTunnel/PingTunnel-0.72.tar.gz'
  sha1 'd5d874ec7b4f68d2307cacc83a1c408aeb4206a5'

  def install
    system "make"
    bin.install "ptunnel"
    man8.install "ptunnel.8"
  end

  def caveats; <<-EOS.undent
    Normally, ptunnel uses raw sockets and must be run as root (using sudo, for example).

    Alternatively, you can try using the -u flag to start ptunnel in 'unprivileged' mode,
    but this is not recommended. See http://www.cs.uit.no/~daniels/PingTunnel/ for details.
    EOS
  end
end

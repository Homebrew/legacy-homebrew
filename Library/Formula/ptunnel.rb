class Ptunnel < Formula
  homepage "http://www.cs.uit.no/~daniels/PingTunnel/"
  url "http://www.cs.uit.no/~daniels/PingTunnel/PingTunnel-0.72.tar.gz"
  sha256 "b318f7aa7d88918b6269d054a7e26f04f97d8870f47bd49a76cb2c99c73407a4"

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  def caveats; <<-EOS.undent
    Normally, ptunnel uses raw sockets and must be run as root (using sudo, for example).

    Alternatively, you can try using the -u flag to start ptunnel in 'unprivileged' mode,
    but this is not recommended. See http://www.cs.uit.no/~daniels/PingTunnel/ for details.
    EOS
  end

  test do
    assert_match "v #{version}", shell_output("#{bin}/ptunnel -h", 1)
  end
end

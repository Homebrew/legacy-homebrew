class Ptunnel < Formula
  desc "Tunnel over ICMP"
  homepage "https://www.cs.uit.no/~daniels/PingTunnel/"
  url "https://www.cs.uit.no/~daniels/PingTunnel/PingTunnel-0.72.tar.gz"
  sha256 "b318f7aa7d88918b6269d054a7e26f04f97d8870f47bd49a76cb2c99c73407a4"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "516181dbd16539c1f8817d65637bd42cc951d551e1a3b61a4d83dc6c71dc6397" => :el_capitan
    sha256 "72db3faba8fbd7c268acf22d02ae0df4dbb5dde2db8a17ca4d62b2293d0763e0" => :yosemite
    sha256 "a39ae93cf1d20d9a24cf194d8b1fde7166b64276056cb084824d4291bd3f8faf" => :mavericks
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  def caveats; <<-EOS.undent
    Normally, ptunnel uses raw sockets and must be run as root (using sudo, for example).

    Alternatively, you can try using the -u flag to start ptunnel in 'unprivileged' mode,
    but this is not recommended. See https://www.cs.uit.no/~daniels/PingTunnel/ for details.
    EOS
  end

  test do
    assert_match "v #{version}", shell_output("#{bin}/ptunnel -h", 1)
  end
end

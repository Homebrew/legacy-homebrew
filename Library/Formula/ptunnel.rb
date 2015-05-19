class Ptunnel < Formula
  desc "Tunnel over ICMP"
  homepage "http://www.cs.uit.no/~daniels/PingTunnel/"
  url "http://www.cs.uit.no/~daniels/PingTunnel/PingTunnel-0.72.tar.gz"
  sha256 "b318f7aa7d88918b6269d054a7e26f04f97d8870f47bd49a76cb2c99c73407a4"

  bottle do
    cellar :any
    sha256 "b2b0466103ab28caf40e4f3c7973ecbd52b4f50c18a91d741fbda96941e44437" => :yosemite
    sha256 "a62f7bef1e4d37a0b3619864e1527c32ff64b26cbd9367e692f585e80e861e9c" => :mavericks
    sha256 "6a3a558951e2ed11a4cb888d02dfde652145eb8175677e6a3b65f9c928117751" => :mountain_lion
  end

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

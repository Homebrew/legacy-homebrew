class Pdnsd < Formula
  desc "Proxy DNS server with permanent caching"
  homepage "http://members.home.nl/p.a.rombouts/pdnsd/"
  url "http://members.home.nl/p.a.rombouts/pdnsd/releases/pdnsd-1.2.9a-par.tar.gz"
  version "1.2.9a-par"
  sha256 "bb5835d0caa8c4b31679d6fd6a1a090b71bdf70950db3b1d0cea9cf9cb7e2a7b"

  bottle do
    cellar :any
    sha256 "a55b3ea9a71be9bee77ddb9ced37f77bc0f37376bf2d66ecdb7780282ae66e35" => :yosemite
    sha256 "4dc63c69195b38fdb977bfcedb97de860d21a61beb0e280634037c1dee8bd455" => :mavericks
    sha256 "473a9d25b7461badb8814355a313595c12240dd8054a6865acf709d85f197da2" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--mandir=#{man}",
                          "--with-cachedir=#{var}/cache/pdnsd"
    system "make", "install"
  end

  test do
    assert_match "version #{version}",
      shell_output("#{sbin}/pdnsd --version", 1)
  end
end

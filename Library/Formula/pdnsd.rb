class Pdnsd < Formula
  homepage "http://members.home.nl/p.a.rombouts/pdnsd/"
  url "http://members.home.nl/p.a.rombouts/pdnsd/releases/pdnsd-1.2.9a-par.tar.gz"
  version "1.2.9a-par"
  sha256 "bb5835d0caa8c4b31679d6fd6a1a090b71bdf70950db3b1d0cea9cf9cb7e2a7b"

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

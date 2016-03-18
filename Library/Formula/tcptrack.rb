class Tcptrack < Formula
  desc "Monitor status of TCP connections on a network interface"
  homepage "http://linux.die.net/man/1/tcptrack"
  url "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/t/tcptrack/tcptrack_1.4.2.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/t/tcptrack/tcptrack_1.4.2.orig.tar.gz"
  sha256 "6607b1e1c778c49d3e8795e119065cf66eb2db28b3255dbc56b1612527107049"

  def install
    ENV.libstdcxx

    # Fix IPv6 on MacOS. The patch was sent by email to the maintainer
    # (tcptrack2@s.rhythm.cx) on 2010-11-24 for inclusion.
    # Still not fixed in 1.4.2 - @adamv
    inreplace "src/IPv6Address.cc", "s6_addr16", "__u6_addr.__u6_addr16"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Run tcptrack as root or via sudo in order for the program
    to obtain permissions on the network interface.
  EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tcptrack -v")
  end
end

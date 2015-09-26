class Tcptraceroute < Formula
  desc "Traceroute implementation using TCP packets"
  homepage "https://github.com/mct/tcptraceroute"
  url "https://github.com/mct/tcptraceroute/archive/tcptraceroute-1.5beta7.tar.gz"
  version "1.5beta7"
  sha256 "57fd2e444935bc5be8682c302994ba218a7c738c3a6cae00593a866cd85be8e7"

  depends_on "libnet"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libnet=#{HOMEBREW_PREFIX}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    tcptraceroute requires root privileges so you will need to run
    `sudo tcptraceroute`.
    You should be certain that you trust any software you grant root privileges.
    EOS
  end
end

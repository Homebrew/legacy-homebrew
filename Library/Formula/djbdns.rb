class Djbdns < Formula
  desc "D.J. Bernstein's DNS tools"
  homepage "http://cr.yp.to/djbdns.html"
  url "http://cr.yp.to/djbdns/djbdns-1.05.tar.gz"
  sha256 "3ccd826a02f3cde39be088e1fc6aed9fd57756b8f970de5dc99fcd2d92536b48"

  depends_on "daemontools"

  def install
    inreplace "hier.c", 'c("/"', "c(auto_home"
    inreplace "dnscache-conf.c", "/etc/dnsroots", "#{etc}/dnsroots"
    system "echo gcc -O2 -include /usr/include/errno.h > conf-cc"
    system "echo #{prefix} > conf-home"
    system "echo gcc > conf-ld"
    bin.mkpath
    (prefix+"etc").mkpath
    system "make setup check"
  end
end

require 'formula'

class Djbdns < Formula
  desc "D.J. Bernstein's DNS tools"
  homepage 'http://cr.yp.to/djbdns.html'
  url 'http://cr.yp.to/djbdns/djbdns-1.05.tar.gz'
  sha1 '2efdb3a039d0c548f40936aa9cb30829e0ce8c3d'

  depends_on 'daemontools'

  def install
    inreplace 'hier.c', 'c("/"', 'c(auto_home'
    inreplace 'dnscache-conf.c', '/etc/dnsroots', "#{etc}/dnsroots"
    system "echo gcc -O2 -include /usr/include/errno.h > conf-cc"
    system "echo #{prefix} > conf-home"
    system "echo gcc > conf-ld"
    bin.mkpath
    (prefix+'etc').mkpath
    system "make setup check"
  end
end

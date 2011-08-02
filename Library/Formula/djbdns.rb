require 'formula'

class Djbdns < Formula
  url 'http://cr.yp.to/djbdns/djbdns-1.05.tar.gz'
  homepage 'http://cr.yp.to/djbdns.html'
  md5 '3147c5cd56832aa3b41955c7a51cbeb2'

  depends_on 'daemontools'

  def install
    inreplace 'hier.c', 'c("/"', 'c(auto_home'
    inreplace 'dnscache-conf.c', '([" ])/etc/dnsroots', "$1#{etc}/dnsroots"
    system "echo gcc -O2 -include /usr/include/errno.h > conf-cc"
    system "echo #{prefix} > conf-home"
    system "echo gcc > conf-ld"
    bin.mkpath
    (prefix+'etc').mkpath
    system "make setup check"
  end
end

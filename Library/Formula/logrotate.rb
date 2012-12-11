require 'formula'

class Logrotate < Formula
  homepage 'http://packages.debian.org/testing/admin/logrotate'
  url 'https://fedorahosted.org/releases/l/o/logrotate/logrotate-3.8.2.tar.gz'
  sha1 '5832a34199e75c24df6c3028494d90145f275234'

  depends_on 'popt'

  def install
    system "make"
    sbin.install 'logrotate'
    man8.install 'logrotate.8'
    man5.install 'logrotate.conf.5'
    (prefix+'etc/logrotate/examples').install Dir['examples/*']
  end
end

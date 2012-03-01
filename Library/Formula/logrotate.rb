require 'formula'

class Logrotate < Formula
  homepage 'http://packages.debian.org/testing/admin/logrotate'
  url 'https://fedorahosted.org/releases/l/o/logrotate/logrotate-3.8.1.tar.gz'
  md5 'bd2e20d8dc644291b08f9215397d28a5'

  depends_on 'popt'

  def install
    system "make"
    sbin.install 'logrotate'
    man8.install 'logrotate.8'
    man5.install 'logrotate.conf.5'
    (prefix+'etc/logrotate/examples').install Dir['examples/*']
  end
end

require 'formula'

class Logrotate < Formula
  homepage 'http://packages.debian.org/testing/admin/logrotate'
  url 'https://fedorahosted.org/releases/l/o/logrotate/logrotate-3.8.1.tar.gz'
  sha1 '1df36cee76a9c4c7438f35ca3599a7bdd68a09b5'

  depends_on 'popt'

  def install
    system "make"
    sbin.install 'logrotate'
    man8.install 'logrotate.8'
    man5.install 'logrotate.conf.5'
    (prefix+'etc/logrotate/examples').install Dir['examples/*']
  end
end

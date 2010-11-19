require 'formula'

class Monit <Formula
  url 'http://mmonit.com/monit/dist/monit-5.2.1.tar.gz'
  homepage 'http://mmonit.com/monit/'
  sha256 '31b37dd4a6f6b48e6d6926d97bfe5ad998a2a0611af0586525a5dd1b5847e41e'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit"
    system "make install"
  end
end

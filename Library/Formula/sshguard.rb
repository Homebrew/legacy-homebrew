require 'formula'

class Sshguard < Formula
  url 'http://downloads.sourceforge.net/project/sshguard/sshguard/sshguard-1.5/sshguard-1.5.tar.bz2'
  homepage 'http://www.sshguard.net/'
  md5 '11b9f47f9051e25bdfe84a365c961ec1'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-firewall=ipfw"
    system "make install"
  end
end

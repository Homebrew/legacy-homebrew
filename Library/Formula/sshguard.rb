require 'formula'

class Sshguard <Formula
  url 'http://downloads.sourceforge.net/project/sshguard/sshguard/sshguard-1.5rc4/sshguard-1.5rc4.tar.bz2'
  homepage 'http://www.sshguard.net/'
  md5 'b25da46b0254879609faa9841a145eba'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-firewall=ipfw"
    system "make install"
  end
end

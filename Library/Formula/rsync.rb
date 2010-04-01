require 'formula'

class Rsync <Formula
  url 'http://rsync.samba.org/ftp/rsync/rsync-3.0.7.tar.gz'
  homepage 'http://rsync.samba.org/'
  md5 'b53525900817cf1ba7ad3a516ab5bfe9'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--with-rsyncd-conf=#{prefix}/etc/rsyncd.conf",
                          "--enable-ipv6"
    system "make install"
  end
end

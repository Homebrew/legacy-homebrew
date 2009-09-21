require 'brewkit'

class Rsync <Formula
  url 'http://rsync.samba.org/ftp/rsync/rsync-3.0.6.tar.gz'
  homepage 'http://rsync.samba.org/'
  md5 'e9865d093a18e4668b9d31b635dc8e99'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--with-rsyncd-conf=#{prefix}/etc/rsyncd.conf",
                          "--enable-ipv6"
    system "make install"
  end
end

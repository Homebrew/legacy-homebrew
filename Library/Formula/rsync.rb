require 'formula'

class Rsync <Formula
  url 'http://rsync.samba.org/ftp/rsync/src/rsync-3.0.8.tar.gz'
  homepage 'http://rsync.samba.org/'
  md5 '0ee8346ce16bdfe4c88a236e94c752b4'

  depends_on 'libiconv'

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-rsyncd-conf=#{prefix}/etc/rsyncd.conf",
                          "--enable-ipv6"
    system "make install"
  end
end

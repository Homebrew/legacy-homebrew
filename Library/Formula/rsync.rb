require 'formula'

class Rsync <Formula
  url 'http://rsync.samba.org/ftp/rsync/rsync-3.0.7.tar.gz'
  homepage 'http://rsync.samba.org/'
  md5 'b53525900817cf1ba7ad3a516ab5bfe9'

  depends_on 'libiconv'

  def patches
    base = "http://trac.macports.org/export/65950/trunk/dports/net/rsync/files"
    {
      :p1 => ["#{base}/patch-fileflags.diff", "#{base}/patch-crtimes.diff"]
    }
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-rsyncd-conf=#{prefix}/etc/rsyncd.conf",
                          "--enable-ipv6"
    system "make install"
  end
end

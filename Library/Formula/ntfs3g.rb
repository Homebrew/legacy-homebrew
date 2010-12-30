require 'formula'

class Ntfs3g <Formula
  url 'http://tuxera.com/opensource/ntfs-3g-2010.10.2.tgz'
  homepage 'http://www.tuxera.com/community/ntfs-3g-download/'
  md5 '91405690f25822142cdcb43d03e62d3f'

  depends_on 'pkg-config'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--exec-prefix=#{prefix}",
                          "--disable-mtab",
                          "--disable-static",
                          "--with-fuse=external"
    system "make install"
  end
end

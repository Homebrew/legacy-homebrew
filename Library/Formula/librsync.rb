require 'formula'

class Librsync <Formula
  url 'http://prdownloads.sourceforge.net/project/librsync/librsync/0.9.7/librsync-0.9.7.tar.gz'
  homepage 'http://librsync.sourceforge.net/'
  md5 '24cdb6b78f45e0e83766903fd4f6bc84'

  def install
    ENV.universal_binary
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end

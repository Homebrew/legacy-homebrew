require 'formula'

class Libtiff <Formula
  @url='ftp://ftp.remotesensing.org/libtiff/tiff-3.9.1.tar.gz'
  @homepage='http://www.libtiff.org/'
  @md5='63c59a44f34ae0787f2d71de3d256e20'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--mandir=#{prefix}/share/man"
    system "make install"
  end
end

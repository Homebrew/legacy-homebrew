require 'formula'

class Libtiff <Formula
  @url='ftp://ftp.remotesensing.org/libtiff/tiff-3.9.2.tar.gz'
  @homepage='http://www.libtiff.org/'
  @md5='93e56e421679c591de7552db13384cb8'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--mandir=#{man}"
    system "make install"
  end
end

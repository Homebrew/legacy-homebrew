require 'brewkit'

class Libtiff <Formula
  @url='ftp://ftp.remotesensing.org/libtiff/tiff-3.8.2.tar.gz'
  @homepage='http://www.libtiff.org/'
  @md5='fbb6f446ea4ed18955e2714934e5b698'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system "make install"

    FileUtils.mv prefix+'man', share
  end
end

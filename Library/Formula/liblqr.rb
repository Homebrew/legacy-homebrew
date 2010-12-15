require 'formula'

class Liblqr <Formula
  url 'http://liblqr.wikidot.com/local--files/en:download-page/liblqr-1-0.4.1.tar.bz2'
  homepage 'http://liblqr.wikidot.com/'
  md5 '0e24ed3c9fcdcb111062640764d7b87a'

  depends_on 'glib'

  def install
    system "./configure", "--enable-install-man", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

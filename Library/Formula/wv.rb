require 'formula'

class Wv < Formula
  url 'http://abisource.com/downloads/wv/1.2.5/wv-1.2.5.tar.gz'
  homepage 'http://wvware.sourceforge.net/'
  md5 'ae506eae4825c93d0cd7939ce6cbae41'

  depends_on 'glib'
  depends_on 'libgsf'
  depends_on 'libwmf'

  def install
    ENV.libxml2
    ENV.libpng
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    ENV.deparallelize
    system "make install"
  end
end

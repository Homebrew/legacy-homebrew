require 'formula'

class Ffmpegthumbnailer <Formula
  url 'http://ffmpegthumbnailer.googlecode.com/files/ffmpegthumbnailer-2.0.4.tar.gz'
  homepage 'http://code.google.com/p/ffmpegthumbnailer/'
  md5 '83b43130e29a26126a50705a011004be'

  depends_on 'jpeg'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--enable-jpeg", "--with-jpeg",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

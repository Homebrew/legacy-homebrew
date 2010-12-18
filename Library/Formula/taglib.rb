require 'formula'

class Taglib <Formula
  url 'http://developer.kde.org/~wheeler/files/src/taglib-1.6.3.tar.gz'
  md5 'ddf02f4e1d2dc30f76734df806e613eb'
  homepage 'http://developer.kde.org/~wheeler/taglib.html'

  def install
    system "./configure", "--enable-mp4", "--enable-asf",
                          "--disable-debug", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
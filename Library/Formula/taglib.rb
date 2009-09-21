require 'brewkit'

class Taglib <Formula
  @url='http://developer.kde.org/~wheeler/files/src/taglib-1.6.tar.gz'
  @md5='5ecad0816e586a954bd676a86237d054'
  @homepage='http://developer.kde.org/~wheeler/taglib.html'

  depends_on 'cmake'

  def install
    system "./configure", "--enable-mp4", "--enable-asf",
                          "--disable-debug", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
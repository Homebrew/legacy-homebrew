require 'formula'

class Ffmpegthumbnailer < Formula
  url 'http://ffmpegthumbnailer.googlecode.com/files/ffmpegthumbnailer-2.0.7.tar.gz'
  homepage 'http://code.google.com/p/ffmpegthumbnailer/'
  md5 '2b5726894792ef484793dce9568a065a'

  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on 'ffmpeg'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

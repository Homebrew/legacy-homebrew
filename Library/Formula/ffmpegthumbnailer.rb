require 'formula'

class Ffmpegthumbnailer < Formula
  homepage 'http://code.google.com/p/ffmpegthumbnailer/'
  url 'http://ffmpegthumbnailer.googlecode.com/files/ffmpegthumbnailer-2.0.8.tar.gz'
  sha1 '2c54ca16efd953f46547e22799cfc40bd9c24533'

  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on 'ffmpeg'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

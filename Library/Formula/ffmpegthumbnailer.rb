require 'formula'

class Ffmpegthumbnailer < Formula
  homepage 'http://code.google.com/p/ffmpegthumbnailer/'
  url 'https://ffmpegthumbnailer.googlecode.com/files/ffmpegthumbnailer-2.0.8.tar.gz'
  sha1 '2c54ca16efd953f46547e22799cfc40bd9c24533'
  revision 1

  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on 'libpng'
  depends_on 'ffmpeg'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

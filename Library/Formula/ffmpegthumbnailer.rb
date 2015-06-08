require 'formula'

class Ffmpegthumbnailer < Formula
  desc "Create thumbnails for your video files"
  homepage 'http://code.google.com/p/ffmpegthumbnailer/'
  url 'https://ffmpegthumbnailer.googlecode.com/files/ffmpegthumbnailer-2.0.8.tar.gz'
  sha1 '2c54ca16efd953f46547e22799cfc40bd9c24533'
  bottle do
    cellar :any
    sha1 "b33cd322e1dd892c3ff492647a9d7fc4b8766388" => :mavericks
    sha1 "18607817d97b20f2fa3a886ac472f3b63e6cb62d" => :mountain_lion
    sha1 "052f2227429e215db559dcbddb2cdca838111d59" => :lion
  end

  revision 2

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

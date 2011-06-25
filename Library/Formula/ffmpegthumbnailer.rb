require 'formula'

class Ffmpegthumbnailer < Formula
  url 'http://ffmpegthumbnailer.googlecode.com/files/ffmpegthumbnailer-2.0.6.tar.gz'
  homepage 'http://code.google.com/p/ffmpegthumbnailer/'
  sha1 'c565eb31910ea03801045e19230870c7e772b1a6'

  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on 'ffmpeg'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"#,
#                          "--enable-jpeg"#, "--with-jpeg"
    system "make install"
  end
end

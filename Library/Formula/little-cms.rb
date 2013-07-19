require 'formula'

class LittleCms < Formula
  homepage 'http://www.littlecms.com/'
  url 'http://downloads.sourceforge.net/project/lcms/lcms/1.19/lcms-1.19.tar.gz'
  sha1 'd5b075ccffc0068015f74f78e4bc39138bcfe2d4'

  option :universal

  depends_on :python => :optional
  depends_on 'jpeg' => :optional
  depends_on 'libtiff' => :optional

  def install
    ENV.universal_binary if build.universal?
    args = %W{--disable-dependency-tracking --disable-debug --prefix=#{prefix}}
    args << "--with-python" if build.with? "python"
    args << "--without-tiff" unless build.with? "tiff"
    args << "--without-jpeg" unless build.with? "jpeg"

    system "./configure", *args
    system "make install"
  end
end

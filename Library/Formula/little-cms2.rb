require 'formula'

class LittleCms2 < Formula
  homepage 'http://www.littlecms.com/'
  url 'http://downloads.sourceforge.net/project/lcms/lcms/2.5/lcms2-2.5.tar.gz'
  sha1 'bab3470471fc7756c5fbe71be9a3c7d677d2ee7b'

  depends_on 'jpeg' => :recommended
  depends_on 'libtiff' => :recommended

  def install
    args = %W{--disable-dependency-tracking --prefix=#{prefix}}
    args << "--without-tiff" if build.without? "libtiff"
    args << "--without-jpeg" if build.without? "jpeg"

    system "./configure", *args
    system "make install"
  end
end

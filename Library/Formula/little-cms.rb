require 'formula'

class LittleCms < Formula
  homepage 'http://www.littlecms.com/'
  url 'http://sourceforge.net/projects/lcms/files/lcms/1.19/lcms-1.19.tar.gz'
  sha1 'd5b075ccffc0068015f74f78e4bc39138bcfe2d4'

  option 'with-python', "Build Python bindings"

  depends_on 'jpeg' => :optional
  depends_on 'libtiff' => :optional

  def install
    args = ["--disable-debug", "--prefix=#{prefix}"]
    args << "--with-python" if build.include? "with-python"

    system "./configure", *args
    system "make install"
  end
end

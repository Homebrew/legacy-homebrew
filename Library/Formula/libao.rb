require 'brewkit'

class Libao <Formula
  @url='http://downloads.xiph.org/releases/ao/libao-0.8.8.tar.gz'
  @md5='b92cba3cbcf1ee9bc221118a85d23dcd'
  @homepage='http://www.xiph.org/ao/'

  def install
    system "./configure --disable-debug --disable-dependency-tracking --prefix='#{prefix}'"
    system "make install"
  end
end
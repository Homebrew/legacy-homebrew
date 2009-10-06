require 'brewkit'

class Libogg <Formula
  @homepage='http://www.xiph.org/ogg/'
  @url='http://downloads.xiph.org/releases/ogg/libogg-1.1.4.tar.gz'
  @md5='10200ec22543841d9d1c23e0aed4e5e9'

  def install
    system "./configure --disable-debug --disable-dependency-tracking --prefix='#{prefix}'"
    system "make"
    ENV.deparallelize
    system "make install"
  end
end
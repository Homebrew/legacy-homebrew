require 'brewkit'

class Libogg <Formula
  @homepage='http://www.xiph.org/ogg/'
  @url='http://downloads.xiph.org/releases/ogg/libogg-1.1.3.tar.gz'
  @md5='eaf7dc6ebbff30975de7527a80831585'

  def install
    system "./configure --disable-debug --disable-dependency-tracking --prefix='#{prefix}'"
    system "make"
    ENV.deparallelize
    system "make install"
  end
end
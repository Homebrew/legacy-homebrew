require 'formula'

class Libebml <Formula
  # This is the official source, but it's frequently down. Use the mktoolnix mirror instead.
  # url 'http://dl.matroska.org/downloads/libebml/libebml-0.7.8.tar.bz2'
  url 'http://www.bunkus.org/videotools/mkvtoolnix/sources/libebml-0.7.8.tar.bz2'
  homepage 'http://www.matroska.org/'
  md5 '6278109f52e4f9d2c8a8dfc0d668b587'

  def install
    system 'cp -r make/linux make/darwin'
    system "cd make/darwin && make install prefix=#{prefix}"
  end
end

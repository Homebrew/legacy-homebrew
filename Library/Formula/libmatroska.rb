require 'formula'

class Libmatroska <Formula
  # This is the official source, but it's frequently down. Use the mktoolnix mirror instead.
  # url 'http://dl.matroska.org/downloads/libmatroska/libmatroska-0.8.1.tar.bz2'
  url 'http://www.bunkus.org/videotools/mkvtoolnix/sources/libmatroska-0.8.1.tar.bz2'
  homepage 'http://www.matroska.org/'
  md5 '2ceb8235e5189fe4e79ec25ebd97b56b'

  depends_on 'libebml'

  def install
    system 'cp -r make/linux make/darwin'
    system "cd make/darwin && make install prefix=#{prefix}"
  end
end

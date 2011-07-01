require 'formula'

class Libmatroska < Formula
  # This is the official source, but it's frequently down. Use the mktoolnix mirror instead.
  # url 'http://dl.matroska.org/downloads/libmatroska/libmatroska-1.2.0.tar.bz2'
  url 'http://www.bunkus.org/videotools/mkvtoolnix/sources/libmatroska-1.2.0.tar.bz2'
  homepage 'http://www.matroska.org/'
  md5 'a4f967f9ade56d5181714f3199ffa241'

  depends_on 'libebml'

  def install
    system 'cp -r make/linux make/darwin'
    system "cd make/darwin && make install prefix=#{prefix}"
  end
end

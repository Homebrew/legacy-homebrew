require 'formula'

class Vorbisgain < Formula
  url 'http://sjeng.org/ftp/vorbis/vorbisgain-0.37.tar.gz'
  homepage 'http://sjeng.org/vorbisgain.html'
  md5 '850b05a7b2b0ee67edb5a27b8c6ac3a2'

  depends_on 'libvorbis'
  depends_on 'libogg'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end

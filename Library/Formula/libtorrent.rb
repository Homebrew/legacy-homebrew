require 'formula'

class Libtorrent <Formula
  url 'http://libtorrent.rakshasa.no/downloads/libtorrent-0.12.5.tar.gz'
  homepage 'http://libtorrent.rakshasa.no/'
  md5 'fe8155d364b220713074423100d4bf29'

  depends_on 'pkg-config'
  depends_on 'libsigc++'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end

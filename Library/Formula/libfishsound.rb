require 'formula'

class Libfishsound <Formula
  url 'http://downloads.xiph.org/releases/libfishsound/libfishsound-1.0.0.tar.gz'
  homepage 'http://xiph.org/fishsound/'
  md5 '02c5c7b361a35c9da3cf311d68800dab'

  depends_on 'pkg-config'
  depends_on 'libvorbis'
  depends_on 'speex' => :optional
  depends_on 'flac' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

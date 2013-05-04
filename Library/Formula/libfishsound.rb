require 'formula'

class Libfishsound < Formula
  homepage 'http://xiph.org/fishsound/'
  url 'http://downloads.xiph.org/releases/libfishsound/libfishsound-1.0.0.tar.gz'
  sha1 '5263dfaa12dce71e30c5d80f871d92869c6b5ce2'

  depends_on 'pkg-config' => :build
  depends_on 'libvorbis'
  depends_on 'speex' => :optional
  depends_on 'flac' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

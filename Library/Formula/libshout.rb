require 'formula'

class Libshout < Formula
  url 'http://downloads.us.xiph.org/releases/libshout/libshout-2.2.2.tar.gz'
  homepage 'http://www.icecast.org/'
  sha1 'cabc409e63f55383f4d85fac26d3056bf0365aac'

  depends_on 'pkg-config' => :build
  depends_on 'libogg'
  depends_on 'libvorbis'

  depends_on 'theora' => :optional
  depends_on 'speex'  => :optional

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

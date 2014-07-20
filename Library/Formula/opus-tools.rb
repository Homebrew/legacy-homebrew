require 'formula'

class OpusTools < Formula
  homepage 'http://www.opus-codec.org'
  url 'http://downloads.xiph.org/releases/opus/opus-tools-0.1.9.tar.gz'
  sha1 '03551ec3b206288e93a2f2bb18768a5a9e033206'

  head do
    url 'https://git.xiph.org/opus-tools.git'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build
  depends_on 'opus'
  depends_on 'flac'
  depends_on 'libogg'

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

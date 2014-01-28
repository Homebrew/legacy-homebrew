require 'formula'

class OpusTools < Formula
  homepage 'http://www.opus-codec.org'
  url 'http://downloads.xiph.org/releases/opus/opus-tools-0.1.8.tar.gz'
  sha1 '71e3cf393399af0231d86434923093ca79eea8ab'

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

require 'formula'

class Opus < Formula
  homepage 'http://www.opus-codec.org'
  url 'http://downloads.xiph.org/releases/opus/opus-1.1.tar.gz'
  sha1 '35005f5549e2583f5770590135984dcfce6f3d58'

  head do
    url 'https://git.xiph.org/opus.git'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking", "--disable-doc",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

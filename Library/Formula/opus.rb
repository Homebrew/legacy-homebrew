require 'formula'

class Opus < Formula
  homepage 'http://www.opus-codec.org'
  url 'http://downloads.xiph.org/releases/opus/opus-1.1.tar.gz'
  sha1 '35005f5549e2583f5770590135984dcfce6f3d58'

  option "with-custom-modes", "Enable custom-modes for opus see http://www.opus-codec.org/docs/html_api-1.1.0/group__opus__custom.html"

  head do
    url 'https://git.xiph.org/opus.git'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  def install
    args = ["--disable-dependency-tracking", "--disable-doc", "--prefix=#{prefix}"]
    args << "--enable-custom-modes" if build.with? "custom-modes"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make install"
  end
end

require 'formula'

class Libbluray < Formula
  homepage 'http://www.videolan.org/developers/libbluray.html'
  url 'ftp://ftp.videolan.org/pub/videolan/libbluray/0.5.0/libbluray-0.5.0.tar.bz2'
  sha1 '1a9c61daefc31438f9165e7681c563d0524b2d3e'

  head do
    url 'git://git.videolan.org/libbluray.git'

    depends_on :automake => :build
    depends_on :autoconf => :build
    depends_on :libtool  => :build
  end

  depends_on 'pkg-config' => :build
  depends_on :freetype => :recommended

  def install
    ENV.libxml2

    args = [
      "--prefix=#{prefix}",
      "--disable-dependency-tracking"
    ]

    args << "--without-freetype" if build.include? 'without-freetype'

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make"
    system "make install"
  end
end

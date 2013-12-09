require 'formula'

class Libbluray < Formula
  homepage 'http://www.videolan.org/developers/libbluray.html'
  url 'ftp://ftp.videolan.org/pub/videolan/libbluray/0.4.0/libbluray-0.4.0.tar.bz2'
  sha1 '39984aae77efde2e0917ed7e183ebf612813d7f3'

  head do
    url 'git://git.videolan.org/libbluray.git'

    depends_on :automake => :build
    depends_on :autoconf => :build
    depends_on :libtool  => :build
  end

  depends_on 'pkg-config' => :build

  def install
    ENV.libxml2

    system "./bootstrap" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end

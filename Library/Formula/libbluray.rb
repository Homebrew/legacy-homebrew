require 'formula'

class Libbluray < Formula
  homepage 'http://www.videolan.org/developers/libbluray.html'
  url 'ftp://ftp.videolan.org/pub/videolan/libbluray/0.2.3/libbluray-0.2.3.tar.bz2'
  sha1 '604396b6051cbdfc56e6009c893f7a95d9d9e020'

  head 'git://git.videolan.org/libbluray.git'

  depends_on 'pkg-config' => :build

  if build.head?
    depends_on :automake => :build
    depends_on :autoconf => :build
    depends_on :libtool  => :build
  end

  def install
    ENV.libxml2

    system "./bootstrap" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end

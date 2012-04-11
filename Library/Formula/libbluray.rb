require 'formula'

class Libbluray < Formula
  homepage 'http://www.videolan.org/developers/libbluray.html'
  head 'git://git.videolan.org/libbluray.git'
  url 'http://static.mouseed.com/src/libbluray/libbluray-0.2.2.tar.bz2'
  mirror 'ftp://ftp.videolan.org/pub/videolan/libbluray/0.2.2/libbluray-0.2.2.tar.bz2'
  md5 'cb3254de43276861ea6b07c603f4651c'

  if MacOS.xcode_version >= "4.3"
    depends_on 'automake' => :build
    depends_on 'libtool' => :build
  end

  def install
    system "./bootstrap"
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

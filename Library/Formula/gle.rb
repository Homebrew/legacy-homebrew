require 'formula'

class Gle < Formula
  homepage 'http://glx.sourceforge.net/'
  url 'http://downloads.sourceforge.net/glx/gle-graphics-4.2.4cf-src.tar.gz'
  version '4.2.4c'
  md5 '5eef0a63ee0077237b8a36fe1a24407f'

  depends_on 'pkg-config' => :build
  depends_on :x11
  depends_on 'jpeg' => :optional
  depends_on 'libtiff' => :optional

  def install
    arch = MacOS.prefer_64_bit? ? "x86_64" : "i386"
    system "./configure", "--prefix=#{prefix}",
                          "--with-arch=#{arch}",
                          "--without-qt"

    inreplace 'Makefile', "MKDIR_P", "mkdir -p"

    system "make"
    ENV.deparallelize
    system "make install"
  end
end

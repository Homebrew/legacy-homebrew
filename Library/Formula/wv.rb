require 'formula'

class Wv < Formula
  homepage 'http://wvware.sourceforge.net/'
  url 'http://abisource.com/downloads/wv/1.2.5/wv-1.2.5.tar.gz'
  sha1 'a196a31ca1c4083436d9414b9bf4809c0fd7c33c'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'libgsf'
  depends_on 'libwmf'
  depends_on :libpng

  def install
    ENV.libxml2
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    ENV.deparallelize
    system "make install"
  end
end

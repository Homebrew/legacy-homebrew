require 'formula'

class Vcdimager < Formula
  homepage 'http://www.gnu.org/software/vcdimager/'
  url 'http://ftpmirror.gnu.org/vcdimager/vcdimager-0.7.24.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/vcdimager/vcdimager-0.7.24.tar.gz'
  sha1 '8c245555c3e21dcbc3d4dbb2ecca74f609545424'

  depends_on 'pkg-config' => :build
  depends_on 'libcdio'
  depends_on 'popt'

  def install
    ENV.libxml2

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end

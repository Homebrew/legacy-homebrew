require 'formula'

class Vcdimager < Formula
  url 'http://ftpmirror.gnu.org/vcdimager/vcdimager-0.7.23.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/vcdimager/vcdimager-0.7.23.tar.gz'
  homepage 'http://www.gnu.org/software/vcdimager/'
  md5 '5e7d80fdbf0037ad20e438f2a9573253'

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

require 'formula'

class Detox < Formula
  homepage 'http://detox.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/detox/detox/1.2.0/detox-1.2.0.tar.bz2'
  sha1 'cfb88a1adefaf4ee3933baf9a6530c102baa47ce'

  def install
    system "./configure", "--mandir=#{man}", "--prefix=#{prefix}"
    system "make"
    (prefix/"etc").mkpath
    (share/"detox").mkpath
    system "make install"
  end
end

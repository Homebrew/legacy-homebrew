require 'formula'

class Tarsnap < Formula
  homepage 'http://www.tarsnap.com/'
  url 'https://www.tarsnap.com/download/tarsnap-autoconf-1.0.32.tgz'
  sha256 '8b7c7de5277e6cac55040e0d0e0c8b0952aa77278f7e14f05f00d6aef46d265d'

  depends_on 'xz' => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-sse2",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make install"
  end
end

require 'formula'

class Tarsnap < Formula
  homepage 'http://www.tarsnap.com/'
  url 'https://www.tarsnap.com/download/tarsnap-autoconf-1.0.34.tgz'
  sha256 '14c0172afac47f5f7cbc58e6442a27a0755685711f9d1cec4195c4f457053811'

  depends_on 'xz' => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-sse2",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make install"
  end
end

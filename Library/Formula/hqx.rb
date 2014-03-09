require 'formula'

class Hqx < Formula
  homepage 'http://code.google.com/p/hqx/'
  url 'https://hqx.googlecode.com/files/hqx-1.1.tar.gz'
  sha1 'bf08ae10db6cce4d29c84524ec13a3101d31db6b'

  depends_on 'devil'

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

require 'formula'

class Libslax < Formula
  homepage 'https://code.google.com/p/libslax/'
  url 'https://libslax.googlecode.com/files/libslax-0.11.23.tar.gz'
  sha1 '0be3d52f8e9f0b048b2816086d5fa3688b0d8364'

  depends_on 'libxml2' if MacOS.version >= 10.7  # Lion's libxml is too old. Need > 2.7.8
  depends_on 'libxslt' if MacOS.version >= 10.7 # Lion's libxslt is too old. Need > 1.1.26

  def install
    ENV.libxml2 if MacOS.mountain_lion?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

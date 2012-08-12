require 'formula'

class Libslax < Formula
  homepage 'https://code.google.com/p/libslax/'
  url 'https://libslax.googlecode.com/files/libslax-0.11.23.tar.gz'
  sha1 '0be3d52f8e9f0b048b2816086d5fa3688b0d8364'

  depends_on 'libtool'  => :build

  # Need newer versions of these libraries
  if MacOS.version <= :lion
    depends_on 'libxml2'
    depends_on 'libxslt'
    depends_on 'curl'
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

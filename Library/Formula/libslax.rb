require 'formula'

class Libslax < Formula
  homepage 'https://code.google.com/p/libslax/'
  url 'http://libslax.googlecode.com/files/libslax-0.11.33.tar.gz'
  sha1 'd36d1b41e06517af6fe0ee397c0fddfe5c440de1'

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

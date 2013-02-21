require 'formula'

class Libslax < Formula
  homepage 'https://code.google.com/p/libslax/'
  url 'http://libslax.googlecode.com/files/libslax-0.14.2.tar.gz'
  sha1 '7b2d60769163761b8103a0b8cf81c173202f300b'

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

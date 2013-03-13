require 'formula'

class Libslax < Formula
  homepage 'https://code.google.com/p/libslax/'
  url 'http://libslax.googlecode.com/files/libslax-0.14.4.tar.gz'
  sha1 '587a4e60f3af134d54e26195cb0b739c20bd7893'

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

require 'formula'

class Libslax < Formula
  homepage 'https://code.google.com/p/libslax/'
  url 'https://libslax.googlecode.com/files/libslax-0.11.29.tar.gz'
  sha1 'a1895a5cfd7af09d0d4066823157a4cbf5409720'

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

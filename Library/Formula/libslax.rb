require 'formula'

class Libslax < Formula
  homepage 'https://code.google.com/p/libslax/'
  url 'http://libslax.googlecode.com/files/libslax-0.14.1.tar.gz'
  sha1 '9844b8c2f52b28ec42f588068c4c04822b9fae2f'

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

require 'formula'

class Libslax < Formula
  homepage 'http://www.libslax.org/'
  url 'https://github.com/Juniper/libslax/archive/0.16.6.tar.gz'
  sha1 'e902566ddb4b2285fa2143712cf0260feb73e2fe'

  head 'https://github.com/Juniper/libslax.git'

  depends_on 'automake' => :build
  depends_on 'libtool'  => :build

  # Need newer versions of these libraries
  depends_on 'libxml2'
  depends_on 'libxslt'
  depends_on 'curl' if MacOS.version <= :lion

  def install
    system "sh ./bin/setup.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

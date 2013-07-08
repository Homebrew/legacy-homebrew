require 'formula'

class Libslax < Formula
  homepage 'http://www.libslax.org/'
  url 'https://github.com/Juniper/libslax/archive/0.16.9.tar.gz'
  sha1 '96676aed054ad25e3a71b9c383a96ba86222438b'

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

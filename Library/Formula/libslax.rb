require 'formula'

class Libslax < Formula
  homepage 'http://www.libslax.org/'
  url 'https://github.com/Juniper/libslax/releases/download/0.16.18/libslax-0.16.18.tar.gz'
  sha1 'c20e29bb18d664fc209bcd176c821f26b2d57c04'

  head 'https://github.com/Juniper/libslax.git'

  depends_on 'automake' => :build if build.head?
  depends_on 'libtool'  => :build
  depends_on 'libxml2'
  depends_on 'libxslt'
  depends_on 'curl' if MacOS.version <= :lion

  def install
    # If build from read run script to run autoconf
    system "sh ./bin/setup.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-libedit"
    system "make install"
  end
end

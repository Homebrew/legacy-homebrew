require 'formula'

class Libslax < Formula
  homepage 'http://www.libslax.org/'
  url 'https://github.com/Juniper/libslax/releases/download/0.16.15/libslax-0.16.15.tar.gz'
  sha1 'ee849585d7af7fd6515862f8f3bf30338ad073ab'

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
                          "--prefix=#{prefix}"
    system "make install"
  end
end

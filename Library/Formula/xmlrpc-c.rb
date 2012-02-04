require 'formula'

class XmlrpcC < Formula
  url 'http://downloads.sourceforge.net/sourceforge/xmlrpc-c/xmlrpc-c-1.16.38.tgz'
  md5 'fabb49e5f1efeffa1bedd15a9131699a'
  homepage 'http://xmlrpc-c.sourceforge.net/'

  def install
    ENV.deparallelize

    # Regenerate configure files so it can generate dynamic libraries
    system "aclocal"
    system "autoconf -f"
    system "glibtoolize"

    # choosing --enable-libxml2-backend to lose some weight and not statically
    # link in expat
    #NOTE seemingly it isn't possible to build dylibs with this thing
    #system "./configure", "--disable-debug", "--enable-libxml2-backend", "--prefix=#{prefix}"

    # --enable-libxml2-backed disables generation of libxmlrpc_xmlparse
    # and makes xmlrpc-c-config output unusable
    system "./configure", "--disable-debug", "--prefix=#{prefix}"

    # There is a bug calling directly make install, cpp libraries are not
    # built
    system "make"
    system "make install"
  end
end

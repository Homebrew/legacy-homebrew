require 'formula'

class Libwebsockets < Formula
  homepage 'http://git.warmcat.com/cgi-bin/cgit/libwebsockets'
  url 'http://git.warmcat.com/cgi-bin/cgit/libwebsockets/snapshot/libwebsockets-1.0-chrome25-firefox17.tar.gz'
  head 'git://git.warmcat.com/libwebsockets', :using => :git
  version '1.0'
  sha1 '370b39eb01dd39307f44790741b2b4e386c74da0'

  depends_on 'libtool' => :build
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build

  def install
    system "glibtoolize"
    system "autoreconf -vfi"
    system "./configure", "--prefix=#{prefix}", "--enable-nofork"
    system "make install"
  end
end

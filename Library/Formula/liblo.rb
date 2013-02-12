require 'formula'

class Liblo < Formula
  homepage 'http://liblo.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/liblo/liblo/0.26/liblo-0.26.tar.gz'
  sha1 '21942c8f19e9829b5842cb85352f98c49dfbc823'

  option "enable-ipv6", "Compile with support for ipv6"

  def install
    args = %W[--disable-debug
              --disable-dependency-tracking
              --prefix=#{prefix}]

    args << "--enable-ipv6" if build.include? "enable-ipv6"

    system "./configure", *args
    system "make install"
  end
end

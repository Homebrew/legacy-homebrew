require 'formula'

class Libwps < Formula
  homepage 'http://libwps.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/libwps/libwps/libwps-0.2.9/libwps-0.2.9.tar.bz2'
  sha1 '04acc2c13485f8b9e714a5d2b4eb3e77f643d23e'

  depends_on 'pkg-config' => :build
  depends_on 'libwpd'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          # Installing Doxygen docs trips up make install
                          "--prefix=#{prefix}", "--without-docs"
    system "make install"
  end
end

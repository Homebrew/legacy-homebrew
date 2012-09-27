require 'formula'

class Libwps < Formula
  homepage 'http://libwps.sourceforge.net'
  url 'http://sourceforge.net/projects/libwps/files/libwps/libwps-0.2.7/libwps-0.2.7.tar.bz2'
  sha1 'ccd0b0083a367f293be85f7cea5ba9a8a4355d5c'

  depends_on 'pkg-config' => :build
  depends_on 'libwpd'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          # Installing Doxygen docs trips up make install
                          "--prefix=#{prefix}", "--without-docs"
    system "make install"
  end
end

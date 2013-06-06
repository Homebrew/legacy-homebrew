require 'formula'

class Libwps < Formula
  homepage 'http://libwps.sourceforge.net'
  url 'http://sourceforge.net/projects/libwps/files/libwps/libwps-0.2.8/libwps-0.2.8.tar.bz2'
  sha1 '6af0f161a39198f6a509aa6360398b46c94bd56c'

  depends_on 'pkg-config' => :build
  depends_on 'libwpd'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          # Installing Doxygen docs trips up make install
                          "--prefix=#{prefix}", "--without-docs"
    system "make install"
  end
end

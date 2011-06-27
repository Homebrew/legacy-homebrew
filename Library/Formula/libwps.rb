require 'formula'

class Libwps < Formula
  homepage 'http://libwps.sourceforge.net'
  url 'http://sourceforge.net/projects/libwps/files/libwps/libwps-0.2.2/libwps-0.2.2.tar.bz2'
  md5 '29721a16f25967d59969d5f0ae485b4a'

  depends_on 'pkg-config' => :build
  depends_on 'libwpd'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          # Installing Doxygen docs trips up make install
                          "--prefix=#{prefix}", "--without-docs"
    system "make install"
  end
end

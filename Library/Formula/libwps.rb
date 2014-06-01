require 'formula'

class Libwps < Formula
  homepage 'http://libwps.sourceforge.net'
  url 'https://downloads.sourceforge.net/libwps/libwps-0.3.0.tar.bz2'
  sha1 '526323bd59b5f59f8533882fb455e5886bf1f6dc'

  depends_on 'pkg-config' => :build
  depends_on 'libwpd'
  depends_on 'librevenge'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          # Installing Doxygen docs trips up make install
                          "--prefix=#{prefix}", "--without-docs"
    system "make install"
  end
end

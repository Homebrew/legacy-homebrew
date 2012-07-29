require 'formula'

class Writerperfect < Formula
  url 'http://downloads.sourceforge.net/libwpd/writerperfect-0.8.1.tar.bz2'
  md5 '82d6b9ae2e9699899766beb322b898d2'
  homepage 'http://libwpd.sourceforge.net/'

  depends_on 'pkg-config' => :build
  depends_on "libwpg"
  depends_on "libwpd"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

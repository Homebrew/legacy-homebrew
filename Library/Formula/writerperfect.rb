require 'formula'

class Writerperfect < Formula
  url 'http://downloads.sourceforge.net/libwpd/writerperfect-0.8.0.tar.bz2'
  md5 'cb55b682737ee99cff9c632f0b360372'
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

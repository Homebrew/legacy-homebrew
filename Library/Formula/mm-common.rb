require 'formula'

class MmCommon < Formula
  homepage 'http://www.gtkmm.org'
  url 'http://ftp.gnome.org/pub/GNOME/sources/mm-common/0.9/mm-common-0.9.6.tar.xz'
  sha256 '7c37158a1f37604705a9b9305d3b335fb8256f5de701c8801269dde4e2ce7dde'

  def install
    system "./configure", "--disable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end
end

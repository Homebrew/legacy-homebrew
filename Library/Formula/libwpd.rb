require 'formula'

class Libwpd <Formula
  url 'http://prdownloads.sourceforge.net/libwpd/libwpd-0.8.14.tar.bz2'
  md5 '974784f0cf067900bb8836b4d107101b'
  homepage 'http://libwpd.sourceforge.net/'

  depends_on "glib"
  depends_on "libgsf"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

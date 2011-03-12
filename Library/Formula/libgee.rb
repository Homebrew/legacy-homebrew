require 'formula'

class Libgee <Formula
  url 'http://download.gnome.org/sources/libgee/0.6/libgee-0.6.1.tar.bz2'
  homepage 'http://live.gnome.org/Libgee'
  md5 '9cf60f41f3aa10ac7f1f7e1d094e05a1'

  depends_on 'vala'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end

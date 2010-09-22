require 'formula'

class Libgee <Formula
  url 'http://download.gnome.org/sources/libgee/0.5/libgee-0.5.3.tar.bz2'
  homepage 'http://live.gnome.org/Libgee'
  md5 '1be8ea04c2e2159a45aea9fae1b688dc'

  depends_on 'vala'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end

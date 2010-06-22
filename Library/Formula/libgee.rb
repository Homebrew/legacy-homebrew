require 'formula'

class Libgee <Formula
  url 'http://download.gnome.org/sources/libgee/0.5/libgee-0.5.1.tar.bz2'
  homepage 'http://live.gnome.org/Libgee'
  md5 '59789b5b266beadfb8b51bf2c96211b3'

  depends_on 'vala'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end

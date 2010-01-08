require 'formula'

class Libgee <Formula
  url 'http://download.gnome.org/sources/libgee/0.5/libgee-0.5.0.tar.bz2'
  homepage 'http://live.gnome.org/Libgee'
  md5 '45e3e069dc3488e4bfe0c8411b85b987'

  depends_on 'vala'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

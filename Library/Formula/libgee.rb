require 'formula'

class Libgee < Formula
  url 'http://download.gnome.org/sources/libgee/0.6/libgee-0.6.3.tar.bz2'
  homepage 'http://live.gnome.org/Libgee'
  sha256 'fc3479d692752289c6c1e312fdd79d1f9fdf5322d16fa8f4faf0d6a5e61c5af8'

  depends_on 'vala'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end

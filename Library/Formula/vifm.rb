require 'formula'

class Vifm < Formula
  homepage 'http://vifm.sourceforge.net/index.html'
  url 'http://sourceforge.net/projects/vifm/files/vifm-0.7.5.tar.bz2'
  sha1 '202b369b45d741e32a50084d902c4dcc33014915'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

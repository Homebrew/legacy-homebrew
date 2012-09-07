require 'formula'

class Giblib < Formula
  url 'http://linuxbrit.co.uk/downloads/giblib-1.2.4.tar.gz'
  homepage 'http://freshmeat.net/projects/giblib'
  sha1 '342e6f7882c67d2277e1765299e1be5078329ab0'

  depends_on 'imlib2' => :build
  depends_on :x11 # includes <X11/Xlib.h>

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/giblib-config", "--version"
  end
end

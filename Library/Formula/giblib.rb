require 'formula'

class Giblib < Formula
  homepage 'http://freshmeat.net/projects/giblib'
  url 'http://linuxbrit.co.uk/downloads/giblib-1.2.4.tar.gz'
  sha1 '342e6f7882c67d2277e1765299e1be5078329ab0'

  depends_on :x11
  depends_on 'imlib2' => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/giblib-config", "--version"
  end
end

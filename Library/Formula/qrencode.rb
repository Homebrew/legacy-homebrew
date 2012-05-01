require 'formula'

class Qrencode < Formula
  homepage 'http://fukuchi.org/works/qrencode/index.html.en'
  url 'http://fukuchi.org/works/qrencode/qrencode-3.3.0.tar.gz'
  sha1 '7e7143b2a2b925d77f2d9bae8135c1b7f027af8e'

  depends_on 'pkg-config' => :build

  def install
    ENV.x11 # For libpng

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

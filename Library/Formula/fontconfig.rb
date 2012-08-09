require 'formula'

class Fontconfig < Formula
  homepage 'http://fontconfig.org/'
  url 'http://fontconfig.org/release/fontconfig-2.10.1.tar.gz'
  sha1 'e377cbe989cd22d3a10020309c906ecbbcac0043'

  keg_only :provided_by_osx,
    "Leopard comes with version 2.4.x, which is too old for many packages." \
    if MacOS::X11.installed?

  depends_on :freetype
  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

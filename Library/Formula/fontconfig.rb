require 'formula'

class Fontconfig < Formula
  homepage 'http://fontconfig.org/'
  url 'http://fontconfig.org/release/fontconfig-2.10.1.tar.gz'
  sha1 'e377cbe989cd22d3a10020309c906ecbbcac0043'

  keg_only :when_xquartz_installed

  depends_on :freetype
  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

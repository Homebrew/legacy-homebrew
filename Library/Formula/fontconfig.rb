require 'formula'

class Fontconfig < Formula
  homepage 'http://fontconfig.org/'
  url 'http://fontconfig.org/release/fontconfig-2.10.95.tar.bz2'
  sha1 'f9f4a25b730a9c56f951db6fec639ddeeb92a9d4'

  bottle do
    # Included with X11 so no bottle needed before Mountain Lion.
    sha1 '8429234eb972b93a02dba0925d23c10c1705da77' => :mavericks
    sha1 '8f5835b617380b08d2b38e1f0ee4ee976daa34c5' => :mountain_lion
  end

  keg_only :provided_pre_mountain_lion

  option :universal

  depends_on :freetype
  depends_on 'pkg-config' => :build

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--with-add-fonts=/Library/Fonts,~/Library/Fonts",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

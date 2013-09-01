require 'formula'

class Fontconfig < Formula
  homepage 'http://fontconfig.org/'
  url 'http://fontconfig.org/release/fontconfig-2.10.93.tar.bz2'
  sha1 '78a87be2a59b0c803bfd69cdafc85cbc31381d3a'

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

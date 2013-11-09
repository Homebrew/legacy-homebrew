require 'formula'

class Fontconfig < Formula
  homepage 'http://fontconfig.org/'
  url 'http://fontconfig.org/release/fontconfig-2.11.0.tar.bz2'
  sha1 '969818b0326ac08241b11cbeaa4f203699f9b550'

  bottle do
    # Included with X11 so no bottle needed before Mountain Lion.
    sha1 'fe9ea7cf87a3f442571a93fda6ed539f74b5ecea' => :mavericks
    sha1 '5ed39070bb5b0d7316d14567e0b952725fec4e58' => :mountain_lion
  end

  keg_only :provided_pre_mountain_lion

  option :universal

  depends_on :freetype
  depends_on 'pkg-config' => :build

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-add-fonts=/Library/Fonts,~/Library/Fonts",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

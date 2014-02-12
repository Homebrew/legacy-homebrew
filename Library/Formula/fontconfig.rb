require 'formula'

class Fontconfig < Formula
  homepage 'http://fontconfig.org/'
  url 'http://fontconfig.org/release/fontconfig-2.11.0.tar.bz2'
  sha1 '969818b0326ac08241b11cbeaa4f203699f9b550'

  bottle do
    revision 1
    sha1 '75aac7c039827ca3581116466cc7328c44eab4d6' => :mavericks
    sha1 'ee6d064b5381c7d1884695bce1a0e39f2dfc15a5' => :mountain_lion
    sha1 '7fc50a2d18fd503769aa70fd3811a12f5e8b03bf' => :lion
  end

  keg_only :provided_pre_mountain_lion

  option :universal

  depends_on :freetype
  depends_on 'pkg-config' => :build

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-add-fonts=/System/Library/Fonts,/Library/Fonts,~/Library/Fonts",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}"
    system "make install"
  end

  def post_install
    system "#{bin}/fc-cache", "-frv"
  end
end

class HicolorIconTheme < Formula
  desc "Fallback theme for FreeDesktop.org icon themes"
  homepage "https://wiki.freedesktop.org/www/Software/icon-theme/"
  url "https://icon-theme.freedesktop.org/releases/hicolor-icon-theme-0.15.tar.xz"
  sha256 "9cc45ac3318c31212ea2d8cb99e64020732393ee7630fa6c1810af5f987033cc"

  head do
    url "https://anongit.freedesktop.org/git/xdg/default-icon-theme.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a20e0c97ba6ba84166230805792f878bdc24f21861d0b43820ee6fcdde1e12c3" => :el_capitan
    sha256 "e1e09d7dee2b5560d45d99a310d8e2903d30413eb53408a4079261e8ef5f3b55" => :yosemite
    sha256 "e3e7a63d5af66fe6721839c12e00288e061ef092a046ff6db2dcc6f62f75b9c2" => :mavericks
    sha256 "5647ecc1f44a15ee6cef8d37ae62d606251a0ae94f2659c9fac497270876367e" => :mountain_lion
  end

  def install
    args = %W[--prefix=#{prefix} --disable-silent-rules]
    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    File.exist? share/"icons/hicolor/index.theme"
  end
end

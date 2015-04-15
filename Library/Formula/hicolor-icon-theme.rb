class HicolorIconTheme < Formula
  homepage "https://wiki.freedesktop.org/www/Software/icon-theme/"
  url "http://icon-theme.freedesktop.org/releases/hicolor-icon-theme-0.15.tar.xz"
  sha256 "9cc45ac3318c31212ea2d8cb99e64020732393ee7630fa6c1810af5f987033cc"

  head do
    url "http://anongit.freedesktop.org/git/xdg/default-icon-theme.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  bottle do
    cellar :any
    revision 1
    sha1 "9f3bd40e44a26a00b741f29fe86618a3cb8b570a" => :yosemite
    sha1 "930f46d4d40d82e17af141cbecaf5e51f5ccad09" => :mavericks
    sha1 "aa796a38b6672816314527f318d17f6bc6ad136b" => :mountain_lion
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

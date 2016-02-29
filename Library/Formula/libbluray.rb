class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/pub/videolan/libbluray/0.9.2/libbluray-0.9.2.tar.bz2"
  sha256 "efc994f42d2bce6af2ce69d05ba89dbbd88bcec7aca065de094fb3a7880ce7ea"
  revision 2

  bottle do
    cellar :any
    sha256 "81b4a81674157bd4cced8a4240e613177c3c1cf5246fe41cab62ea2925b895fc" => :el_capitan
    sha256 "f77fbd28b4dd80f57a5c9c0131adcc49191a4a56919b9e8501a82f1a438277b5" => :yosemite
    sha256 "e6e2fcf12d691a830d8a67993272f5d1a06e9b7c19489c47347a8b6820dd149e" => :mavericks
  end

  head do
    url "https://git.videolan.org/git/libbluray.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "without-ant", "Disable Support for BD Java"

  depends_on "pkg-config" => :build
  depends_on "freetype" => :recommended
  depends_on "fontconfig"
  depends_on "ant" => [:build, :optional]

  def install
    # https://mailman.videolan.org/pipermail/libbluray-devel/2014-April/001401.html
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE"
    ENV.libxml2

    args = %W[--prefix=#{prefix} --disable-dependency-tracking]
    args << "--without-freetype" if build.without? "freetype"
    args << "--disable-bdjava" if build.without? "ant"

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end
end

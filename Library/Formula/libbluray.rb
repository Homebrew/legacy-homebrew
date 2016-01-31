class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/pub/videolan/libbluray/0.9.2/libbluray-0.9.2.tar.bz2"
  sha256 "efc994f42d2bce6af2ce69d05ba89dbbd88bcec7aca065de094fb3a7880ce7ea"
  revision 1

  bottle do
    cellar :any
    sha256 "c4846d3177db8aa304557818adb03a0a7e8b49cc5dcd2b699b3759ea7a9c6e14" => :el_capitan
    sha256 "841c95e8ca17c6353ef5bfdbf4ce286eaf69156f804e70c6e775d7abc4d49e2f" => :yosemite
    sha256 "52659042ef08c69a3b7325bdda9f76e9d1bcff090d00908905e090e6697bba7e" => :mavericks
  end

  head do
    url "git://git.videolan.org/libbluray.git"

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

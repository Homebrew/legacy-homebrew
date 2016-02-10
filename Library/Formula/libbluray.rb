class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/pub/videolan/libbluray/0.9.2/libbluray-0.9.2.tar.bz2"
  sha256 "efc994f42d2bce6af2ce69d05ba89dbbd88bcec7aca065de094fb3a7880ce7ea"
  revision 2

  bottle do
    cellar :any
    sha256 "f695851e0ca815f907a55f71a99f96e7819d79c40bb24a1ee0be635eca2ad1eb" => :el_capitan
    sha256 "1e8a6176e026e1c32b2eb4942ebbfdcb3e6b923ac7924a985599cf0584c24a21" => :yosemite
    sha256 "d9361e19dd6d272e2e655d499cd17a1aed9c3f6628eab90e3505fc1cb90f349a" => :mavericks
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

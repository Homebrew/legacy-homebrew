class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/pub/videolan/libbluray/0.8.1/libbluray-0.8.1.tar.bz2"
  sha256 "cdbec680c5bbc2251de6ccd109cf5f798ea51db6fcb938df39283be1799efb8f"

  bottle do
    cellar :any
    revision 1
    sha256 "721af230aeca4ac6e17c6799c7dbf73b8f7f14128983e1d0c3eaa8d6a80894b5" => :yosemite
    sha256 "ebcaf7958d95d7e6a616f8146f0034a75d4e68a65f0a1b1d192eff0a88404df4" => :mavericks
    sha256 "cc6ec61dfab7f26ba47ddd5195c109dbc1c1f28726dc48147ed7a00e5d207f82" => :mountain_lion
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

class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/pub/videolan/libbluray/0.8.1/libbluray-0.8.1.tar.bz2"
  sha256 "cdbec680c5bbc2251de6ccd109cf5f798ea51db6fcb938df39283be1799efb8f"

  bottle do
    cellar :any
    sha256 "33e711f8364371ebdf47183f09864321a185d8769c17a745aef4649d79deaa86" => :yosemite
    sha256 "f161eb07eb035181aac218d9ff22323db5ff9891e432fcc101964b5bfc241b95" => :mavericks
    sha256 "f39ea94c14fd752e203033670fbe268f59048f4a420b2f2b72688a40b975e759" => :mountain_lion
  end

  head do
    url "git://git.videolan.org/libbluray.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "freetype" => :recommended
  depends_on "fontconfig"
  depends_on "ant" => :build

  def install
    # https://mailman.videolan.org/pipermail/libbluray-devel/2014-April/001401.html
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE"
    ENV.libxml2

    args = %W[--prefix=#{prefix} --disable-dependency-tracking]
    args << "--without-freetype" if build.without? "freetype"

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end
end

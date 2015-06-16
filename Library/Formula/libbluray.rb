class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/pub/videolan/libbluray/0.8.1/libbluray-0.8.1.tar.bz2"
  sha256 "cdbec680c5bbc2251de6ccd109cf5f798ea51db6fcb938df39283be1799efb8f"

  bottle do
    cellar :any
    sha1 "39d4a2de13f0c3302372c0fafa8587b78054d610" => :yosemite
    sha1 "86036b1e6da82caeb8356b80d759bbce2aa31a08" => :mavericks
    sha1 "7c2a0946331bf2cd658c9c99aed2bf40d957b55b" => :mountain_lion
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

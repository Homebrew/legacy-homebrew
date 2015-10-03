class Mdbtools < Formula
  desc "Tools to facilitate the use of Microsoft Access databases"
  homepage "https://github.com/brianb/mdbtools/"
  url "https://github.com/brianb/mdbtools/archive/0.7.1.tar.gz"
  sha256 "dcf310dc7b07e7ad2f9f6be16047dc81312cfe1ab1bd94d0fa739c8059af0b16"

  option "with-man-pages", "Build manual pages"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "txt2man" => :build if build.with? "man-pages"
  depends_on "glib"
  depends_on "readline"

  def install
    ENV.deparallelize

    args = ["--prefix=#{prefix}"]
    args << "--disable-man" if build.without? "man-pages"

    if MacOS.version == :snow_leopard
      mkdir "build-aux"
      touch "build-aux/config.rpath"
    end

    system "autoreconf", "-i", "-f"
    system "./configure", *args
    system "make", "install"
  end
end

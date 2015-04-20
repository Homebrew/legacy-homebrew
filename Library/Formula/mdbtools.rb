require 'formula'

class Mdbtools < Formula
  homepage 'https://github.com/brianb/mdbtools/'
  url "https://github.com/brianb/mdbtools/archive/0.7.1.tar.gz"
  sha1 '33b746f29c1308909a1e82546ec24e8f835d461a'

  option 'with-man-pages', 'Build manual pages'

  depends_on 'pkg-config' => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on 'txt2man' => :build if build.with? "man-pages"
  depends_on 'glib'
  depends_on 'readline'

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
    system "make install"
  end
end

require "formula"

class Wv < Formula
  homepage "http://wvware.sourceforge.net/"
  url "http://abisource.com/downloads/wv/1.2.9/wv-1.2.9.tar.gz"
  sha1 "db4717a151742dbdb492318f104504a92075543a"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libgsf"
  depends_on "libwmf"
  depends_on "libpng"

  def install
    ENV.libxml2
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    ENV.deparallelize
    # the makefile generated does not create the file structure when installing
    # till it is fixed upstream, create the target directories here.
    # http://www.abisource.com/mailinglists/abiword-dev/2011/Jun/0108.html

    bin.mkpath
    (lib/"pkgconfig").mkpath
    (include/"wv").mkpath
    man1.mkpath
    (share/"wv/wingdingfont").mkpath
    (share/"wv/patterns").mkpath

    system "make install"
  end
end

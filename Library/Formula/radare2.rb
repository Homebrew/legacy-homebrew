require 'formula'

class Radare2 < Formula
  homepage 'http://radare.org'
  url 'http://radare.org/get/radare2-0.9.7.tar.xz'
  sha1 '34af6c6ba53ac08c852b4e110ac6908054616b9d'

  head 'http://radare.org/hg/radare2', :using => :hg

  depends_on "pkg-config" => :build
  depends_on "valabind" => :build
  depends_on "swig" => :build
  depends_on "gobject-introspection" => :build
  depends_on "libewf"
  depends_on "libmagic"
  depends_on "gmp"
  depends_on "lua"

  # Fixes file name of dynamic libraries so that version goes before .dylib.
  #  * radare2 pull request #693
  patch do
    url "https://github.com/radare/radare2/commit/f0dbeb9950c55cdb75a2515b1cf6add4e0f4a591.diff"
    sha1 "1b02e071728c2ef9b328e25ae46eac15eed391be"
  end

  resource "bindings" do
    url "http://radare.org/get/radare2-bindings-0.9.7.tar.xz"
    sha1 "b425e3faeebd3f212e6542a64dafa3b629535e7a"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    resource("bindings").stage do
      ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"

      # OSX build fix from pull request #18.
      #  * https://github.com/radare/radare2-bindings/pull/18
      inreplace "python-config-wrapper" do |s|
        s.gsub! "\s", "\ "
      end

      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make", "install", "DESTDIR=#{prefix}"
    end
  end
end

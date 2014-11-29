require "formula"

class Radare2 < Formula
  homepage "http://radare.org"
  revision 2

  stable do
    url "http://radare.org/get/radare2-0.9.7.tar.xz"
    sha1 "34af6c6ba53ac08c852b4e110ac6908054616b9d"

    # Fixes file name of dynamic libraries so that version goes before .dylib.
    # *radare2 pull request #693
    patch do
      url "https://github.com/radare/radare2/commit/f0dbeb9950c55cdb75a2515b1cf6add4e0f4a591.diff"
      sha1 "1b02e071728c2ef9b328e25ae46eac15eed391be"
    end

    resource "bindings" do
      url "http://radare.org/get/radare2-bindings-0.9.7.tar.xz"
      sha1 "b425e3faeebd3f212e6542a64dafa3b629535e7a"
    end
  end

  bottle do
    sha1 "7bece65a73bd1aab23c5765b3bee164a6e6fdfb6" => :yosemite
    sha1 "e9fca9c3e8aa86c32f8fda6c1a6d15b6064bbcd6" => :mavericks
    sha1 "5a872355becc0ab276eee5297b951a5814c1e6a6" => :mountain_lion
  end

  head do
    url "https://github.com/radare/radare2.git"

    resource "bindings" do
      url "https://github.com/radare/radare2-bindings.git"
    end
  end

  depends_on "pkg-config" => :build
  depends_on "valabind" => :build
  depends_on "swig" => :build
  depends_on "gobject-introspection" => :build
  depends_on "libewf"
  depends_on "libmagic"
  depends_on "gmp"
  depends_on "lua51" # It seems to latch onto Lua51 rather than Lua. Enquire this upstream.
  depends_on "openssl"

  def install
    # Build Radare2 before bindings, otherwise compile = nope.
    system "./configure", "--prefix=#{prefix}", "--with-openssl"
    system "make"
    system "make", "install"

    resource("bindings").stage do
      ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"

      # https://github.com/radare/radare2-bindings/pull/18
      inreplace "python-config-wrapper", '\s', '\ ' if build.stable?

      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make", "install", "DESTDIR=#{prefix}"
    end
  end
end

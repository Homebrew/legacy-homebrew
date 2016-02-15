class Sile < Formula
  desc "Modern typesetting system inspired by TeX"
  homepage "http://www.sile-typesetter.org/"
  url "https://github.com/simoncozens/sile/releases/download/v0.9.2/sile-0.9.2.tar.bz2"
  sha256 "2223582818df06daa4609cee40a81e8787085ad1795d4b2ce5edbe0663b74e18"

  head do
    url "https://github.com/simoncozens/sile.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "harfbuzz"
  depends_on "fontconfig"
  depends_on "libpng"
  depends_on "freetype"
  depends_on "lua"

  depends_on "lpeg" => :lua
  depends_on "luaexpat" => :lua
  depends_on "luafilesystem" => :lua

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-lua=#{prefix}",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end

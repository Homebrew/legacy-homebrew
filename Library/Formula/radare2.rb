class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "http://radare.org"

  stable do
    url "http://radare.org/get/radare2-0.9.9.tar.xz"
    sha256 "024adba5255f12e58c2c1a5e2263fada75aad6e71b082461dea4a2b94b29df32"

    resource "bindings" do
      url "http://radare.org/get/radare2-bindings-0.9.9.tar.xz"
      sha256 "817939698cc4534498226c28938288b7b4a7b6216dc6d7ddde72b0f94d987b14"
    end

    # https://github.com/radare/radare2/issues/3019
    # Also fixes dylib naming issue with https://github.com/radare/radare2/commit/a497a6cf5b19da8bb857803e582a3afb3d4af673
    patch do
      url "https://gist.githubusercontent.com/sparkhom/d4584cfefb58243995e8/raw/cb62b0e45d62832efb0db037de5a63cfa895bfa0/radare2-0.9.9-homebrew.patch"
      sha256 "9b032de6e31ffeb302384a3fed284fee8a14b7b452405789419e78a15cb83145"
    end
  end

  bottle do
    revision 1
    sha256 "c4a3cbed5b9aaf4d6b1970aec1e7b167f64ad4f0d92139f38892fcb0d5daae6c" => :el_capitan
    sha256 "2d812da8bb6b00e1cf74fbf475b8709d9b01c22a1e1af547ff5b4adbabf7fef4" => :yosemite
    sha256 "d482c0080aa58f7254e93527a498122810367bceefb2eeebb88539aad6a3f407" => :mavericks
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

      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make", "install", "DESTDIR=#{prefix}"
    end
  end
end

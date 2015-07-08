require "formula"

class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "http://radare.org"

  stable do
    url "http://radare.org/get/radare2-0.9.8.tar.xz"
    sha256 "8e72caaebdac10300fd7ec86a5d06b1cbecfc6914e5fea4007c6e06e667bfa5a"

    resource "bindings" do
      url "http://radare.org/get/radare2-bindings-0.9.8.tar.xz"
      sha256 "28326effb7d1eda9f6df2ef08954774c16617046a33046501bd0332324519f39"
    end
  end

  bottle do
    sha256 "98747f4956734786ab429187042f2371b6c0b13d29c79af71c465a800e45e60b" => :yosemite
    sha256 "f1896970ded3c078f49c17b674565992a9a9eb291318d1d0ec4003cb17d97433" => :mavericks
    sha256 "939af3b23d3918860ff985156f2a42ad2bff56cd48b8545e9c73bb8cf96a0038" => :mountain_lion
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

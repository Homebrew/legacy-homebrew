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
  end

  bottle do
    sha256 "216089159f3156a4a0ca935c9e29ffb12c0b83afbc98c7ef2b1f0b380edc61a7" => :el_capitan
    sha256 "afb41a571a92455db1a56e7a62d90e5390187bd0fb69df341c42883fad7f3ccf" => :yosemite
    sha256 "a55fa925ab269d44243f4cb95e7251e1eb86add65532ccd7b355f51af27bd9bf" => :mavericks
    sha256 "6445c5acd96375099ed12e47854acd5e1db4354c20e0447caa8b87bb84b147fd" => :mountain_lion
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

  # https://github.com/radare/radare2/issues/3019
  # Also fixes dylib naming issue with https://github.com/radare/radare2/commit/a497a6cf5b19da8bb857803e582a3afb3d4af673
  patch do
    url "https://gist.githubusercontent.com/sparkhom/d4584cfefb58243995e8/raw/cb62b0e45d62832efb0db037de5a63cfa895bfa0/radare2-0.9.9-homebrew.patch"
    sha256 "9b032de6e31ffeb302384a3fed284fee8a14b7b452405789419e78a15cb83145"
  end

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

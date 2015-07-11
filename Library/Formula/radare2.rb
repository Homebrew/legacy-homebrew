require "formula"

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
    ENV["PREFIX"] = prefix
    ENV["INSTALL_TARGET"] = "install"
    ENV["NOSUDO"] = "1"
    ENV["HARDEN"] = "1"
    ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"

    # Build scripts assume this directory already exists
    mkdir_p lib

    # Build script falsely assume this directory is a git repo. Force the
    # fall-back behavior of re-cloning the repo when the directory is missing
    rm_rf "shlr/capstone"

    # Build Radare2 before bindings, otherwise compile = nope.
    system "./sys/install.sh"

    resource("bindings").stage do
      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make", "install", "DESTDIR=#{prefix}"
    end
  end
end

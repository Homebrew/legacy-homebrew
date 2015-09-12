class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "http://radare.org"
  revision 1

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
      ENV.append_path "PATH", "#{bin}"
      ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"

      # Language versions.
      perl_version = `/usr/bin/perl -e 'printf "%vd", $^V;'`
      lua_version = "5.1"

      # Lazily bind to Python.
      inreplace "do-swig.sh", "VALABINDFLAGS=\"\"", "VALABINDFLAGS=\"--nolibpython\""
      make_binding_args = ["CFLAGS=-undefined dynamic_lookup"]

      # Ensure that plugins and bindings are installed in the correct Cellar
      # paths.
      inreplace "libr/lang/p/Makefile", "R2_PLUGIN_PATH=", "#R2_PLUGIN_PATH="
      inreplace "Makefile", "LUAPKG=", "#LUAPKG="
      inreplace "Makefile", "$$target/r2", "$(PERLPATH)/r2"
      inreplace "Makefile", "${DESTDIR}$$_LUADIR", "#{lib}/lua/#{lua_version}"
      make_install_args = ["R2_PLUGIN_PATH=#{lib}/radare2/#{version}",
                           "LUAPKG=lua-#{lua_version}",
                           "PERLPATH=#{lib}/perl5/site_perl/#{perl_version}",
                           "PYTHON_PKGDIR=#{lib}/python2.7/site-packages",]

      system "./configure", "--prefix=#{prefix}"
      ["lua", "perl", "python"].each do |binding|
        system "make", "-C", binding, *make_binding_args
      end
      system "make"
      system "make", "install", *make_install_args
    end
  end
end

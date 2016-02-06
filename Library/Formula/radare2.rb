class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "http://radare.org"

  stable do
    url "http://radare.org/get/radare2-0.10.0.tar.xz"
    sha256 "f7a755e4ff2d5fb9258be6c9b7ffa708b0533e0d1efce4ced177785a9270befd"

    resource "bindings" do
      url "http://radare.org/get/radare2-bindings-0.10.0.tar.xz"
      sha256 "f7f10e308c7bd6edc3ddf8d2229fa9647cdee0474134ba9120ee163723e475cf"
    end

    resource "extras" do
      url "http://radare.org/get/radare2-extras-0.10.0.tar.xz"
      sha256 "363fef80e39dff18c4b8263f3f4eb355c7f89aba3339505b3a37acb82fea053e"
    end
  end

  bottle do
    sha256 "c1d789306650ae76fcc2c00cfa9f1eaef12c27fa0179b60655968d54fe24cf54" => :el_capitan
    sha256 "5d0264d2a107c5ccb94b9d54191c51aeaf153e998a8e12f7073cae96882240e8" => :yosemite
    sha256 "71062439da10ac541505d0124f1540c9cf434f64511b3e00bc83fc568c575018" => :mavericks
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
  depends_on "gmp"
  depends_on "libewf"
  depends_on "libmagic"
  depends_on "lua51" # It seems to latch onto Lua51 rather than Lua. Enquire this upstream.
  depends_on "openssl"
  depends_on "yara"

  def install
    # Build Radare2 before bindings, otherwise compile = nope.
    system "./configure", "--prefix=#{prefix}", "--with-openssl"
    system "make", "CS_PATCHES=0"
    system "make", "install"

    resource("extras").stage do
      ENV.append_path "PATH", "#{bin}"
      ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"

      system "./configure", "--prefix=#{prefix}"
      system "make", "all"
      system "make", "install"
    end

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

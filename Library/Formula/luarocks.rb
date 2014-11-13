require "formula"

class Luarocks < Formula
  homepage "http://luarocks.org"
  url "http://luarocks.org/releases/luarocks-2.2.0.tar.gz"
  sha1 "e2de00f070d66880f3766173019c53a23229193d"
  revision 1

  bottle do
    sha1 "0cebc71f659d0c4ad071ca92d58af25e2282440d" => :mavericks
    sha1 "a7194e000987a02bb3b990dffdb59b6edaa4a53b" => :mountain_lion
    sha1 "105125da47afe836fd0aac346be43c6c4a927abc" => :lion
  end

  head "https://github.com/keplerproject/luarocks.git"

  depends_on "lua"

  fails_with :llvm do
    cause "Lua itself compiles with llvm, but may fail when other software tries to link."
  end

  def install
    # Install to the Cellar, but direct modules to HOMEBREW_PREFIX
    # Specify where the Lua is to avoid accidental conflict.
    lua_prefix = Formula["lua"].opt_prefix

    args = ["--prefix=#{prefix}",
            "--rocks-tree=#{HOMEBREW_PREFIX}",
            "--sysconfdir=#{etc}/luarocks",
            "--with-lua=#{lua_prefix}",
            "--lua-version=5.2"]

    system "./configure", *args
    system "make", "build"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Rocks are installed to: #{HOMEBREW_PREFIX}/lib/luarocks/rocks

    A configuration file has been placed at #{HOMEBREW_PREFIX}/etc/luarocks
    which you can use to specify additional dependency paths as desired.
    See: http://luarocks.org/en/Config_file_format
    EOS
  end

  test do
    system "#{bin}/luarocks", "install", "say"
  end
end

require 'formula'

def use_luajit?; ARGV.include? '--with-luajit'; end

class Luarocks < Formula
  url 'http://luarocks.org/releases/luarocks-2.0.4.1.tar.gz'
  homepage 'http://luarocks.org'
  md5 '2c7caccce3cdf236e6f9aca7bec9bdea'

  depends_on use_luajit? ? 'luajit' : 'lua'

  fails_with_llvm "Lua itself compiles with llvm, but may fail when other software trys to link."

  def options
    [['--with-luajit', 'Use LuaJIT instead of the stock Lua.']]
  end

  def install
    # Install to the Cellar, but direct modules to HOMEBREW_PREFIX
    args = ["--prefix=#{prefix}",
            "--rocks-tree=#{HOMEBREW_PREFIX}/lib/luarocks",
            "--sysconfdir=#{etc}/luarocks"]

    if use_luajit?
      args << "--with-lua-include=#{HOMEBREW_PREFIX}/include/luajit-2.0"
      args << "--lua-suffix=jit"
    end

    system "./configure", *args
    system "make"
    system "make install"
  end

  def test
    opoo "Luarocks test script installs 'lpeg'"
    system "luarocks install lpeg"
    system "lua", "-lluarocks.loader", "-llpeg", "-e", 'print ("Hello World!")'
  end
end

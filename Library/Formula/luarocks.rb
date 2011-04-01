require 'formula'

class Luarocks < Formula
  url 'http://luarocks.org/releases/luarocks-2.0.2.tar.gz'
  homepage 'http://luarocks.org'
  md5 'f8b13b642f8bf16740cac009580cda48'

  depends_on 'lua' unless ARGV.include? '--with-luajit'
  depends_on 'luajit' if ARGV.include? '--with-luajit'

  def options
    [['--with-luajit', 'Use LuaJIT instead of the stock Lua.']]
  end

  def install
    fails_with_llvm "Lua itself compiles with llvm, but may fail when other software trys to link."

    # Install to the Cellar, but direct modules to HOMEBREW_PREFIX
    # Configure can detect 'wget' to use as a downloader, but we don't
    # require it since curl works too and comes with OS X.
    if ARGV.include? '--with-luajit'
      system "./configure", "--prefix=#{prefix}",
                            "--rocks-tree=#{HOMEBREW_PREFIX}/lib/luarocks",
                            "--sysconfdir=#{etc}/luarocks",
                            "--with-lua-include=#{HOMEBREW_PREFIX}/include/luajit-2.0",
                            "--lua-suffix=jit"
    else
      system "./configure", "--prefix=#{prefix}",
                            "--rocks-tree=#{HOMEBREW_PREFIX}/lib/luarocks",
                            "--sysconfdir=#{etc}/luarocks"
    end
    system "make"
    system "make install"
  end

  def test
    opoo "Luarocks test script installs 'lpeg'"
    system "luarocks install lpeg"
    system "lua", "-lluarocks.loader", "-llpeg", "-e", 'print ("Hello World!")'
  end
end

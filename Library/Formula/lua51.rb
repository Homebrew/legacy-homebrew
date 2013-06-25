require 'formula'

class Lua51 < Formula
  homepage 'http://www.lua.org/'
  url 'http://www.lua.org/ftp/lua-5.1.5.tar.gz'
  sha1 'b3882111ad02ecc6b972f8c1241647905cb2e3fc'

  fails_with :llvm do
    build 2326
    cause "Lua itself compiles with LLVM, but may fail when other software tries to link."
  end

  option :universal
  option 'with-completion', 'Enables advanced readline support'
  option 'without-sigaction', 'Use ANSI signal instead of POSIX sigaction'

  V = 5.1

  def patches
    p = []
    # Be sure to build a dylib, or else runtime modules will pull in another static copy of liblua = crashy
    # See: https://github.com/mxcl/homebrew/pull/5043
    # Also, take care of versioned file suffixes to support parallel installation with other releases.
    p << 'https://gist.github.com/gvvaughan/5832455/raw/aad4b63f2fbc7646c62274ef44bb204e5cb5fc7f/lua-5.1-homebrew.diff'
    # sigaction provided by posix signalling power patch from
    # http://lua-users.org/wiki/LuaPowerPatches
    unless build.without? 'sigaction'
      p << 'http://lua-users.org/files/wiki_insecure/power_patches/5.1/sig_catch.patch'
    end
    # completion provided by advanced readline power patch from
    # http://lua-users.org/wiki/LuaPowerPatches
    if build.with? 'completion'
      p << 'http://luajit.org/patches/lua-5.1.4-advanced_readline.patch'
    end
    p
  end

  def install
    ENV.universal_binary if build.universal?

    # Use our CC/CFLAGS to compile.
    inreplace 'src/Makefile' do |s|
      s.remove_make_var! 'CC'
      s.change_make_var! 'CFLAGS', "#{ENV.cflags} $(MYCFLAGS)"
      s.change_make_var! 'MYLDFLAGS', ENV.ldflags
    end

    # Fix path in the config header
    inreplace 'src/luaconf.h', '/usr/local', HOMEBREW_PREFIX

    # Fix paths in the .pc
    inreplace 'etc/lua.pc', "prefix= /usr/local", "prefix=#{HOMEBREW_PREFIX}"

    # this ensures that this symlinking for lua starts at lib/lua/5.1 and not
    # below that, thus making luarocks work
    (HOMEBREW_PREFIX/"lib/lua/#{V}").mkpath

    system "make", "macosx", "INSTALL_TOP=#{prefix}", "INSTALL_MAN=#{man1}"
    system "make", "install", "INSTALL_TOP=#{prefix}", "INSTALL_MAN=#{man1}"

    # Make wrappers that set environment to find correct rocktree.
    (bin+"lua-#{V}").write wrap_script
    (bin+"luac-#{V}").write wrap_script

    (lib+"lua/#{V}/luarocks-config.lua").write luarocks_cfg_file
  end

  def luarocks_cfg_file; <<-EOS.undent
    rocks_trees = { "#{HOMEBREW_PREFIX}/lib/luarocks/rocks-#{V}" }
    variables = {
      LUA = "#{opt_prefix}/bin/lua-#{V}",
      LUA_BINDIR = "#{opt_prefix}/bin",
      LUA_INCDIR = "#{opt_prefix}/include/lua-#{V}",
      LUA_LIBDIR = "#{opt_prefix}/lib",
    }
    EOS
  end

  def wrap_script; <<-EOS.undent
    #!/bin/sh
    export LUA='#{opt_prefix}/libexec/lua-#{V}'
    export LUAROCKS_CONFIG='#{HOMEBREW_PREFIX}/lib/lua/#{V}/luarocks-config.lua'
    eval `"$LUA" '#{HOMEBREW_PREFIX}/bin/luarocks' path 2>/dev/null`
    exec "$LUA" ${1+"$@"}
    EOS
  end
end

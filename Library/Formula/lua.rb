require 'formula'

class Lua < Formula
  homepage 'http://www.lua.org/'
  url 'http://www.lua.org/ftp/lua-5.2.2.tar.gz'
  sha1 '0857e41e5579726a4cb96732e80d7aa47165eaf5'

  fails_with :llvm do
    build 2326
    cause "Lua itself compiles with LLVM, but may fail when other software tries to link."
  end

  option 'with-completion', 'Enables advanced readline support'
  option 'without-sigaction', 'Revert to ANSI signal instead of improved POSIX sigaction'

  V = 5.2

  def patches
    p = []
    # Be sure to build a dylib, or else runtime modules will pull in another static copy of liblua = crashy
    # See: https://github.com/mxcl/homebrew/pull/5043
    # Also, take care of versioned file suffixes to support parallel installation with other releases
    p << 'https://gist.github.com/gvvaughan/5832054/raw/26c3dfa5712c1fadbba28898158196bc9a39adbf/lua-5.2-homebrew.diff'
    # sigaction provided by posix signalling power patch from
    # http://lua-users.org/wiki/LuaPowerPatches
    unless build.without? 'sigaction'
      p << 'http://lua-users.org/files/wiki_insecure/power_patches/5.2/lua-5.2.2-sig_catch.patch'
    end
    # completion provided by advanced readline power patch from
    # http://lua-users.org/wiki/LuaPowerPatches
    if build.with? 'completion'
      p << 'http://luajit.org/patches/lua-5.2.0-advanced_readline.patch'
    end
    p
  end

  def install
    # Use our CC/CFLAGS to compile.
    inreplace 'src/Makefile' do |s|
      s.remove_make_var! 'CC'
      s.change_make_var! 'CFLAGS', "#{ENV.cflags} -DLUA_COMPAT_ALL $(SYSCFLAGS) $(MYCFLAGS)"
      s.change_make_var! 'MYLDFLAGS', ENV.ldflags
    end

    # Fix path in the config header
    inreplace 'src/luaconf.h', '/usr/local', HOMEBREW_PREFIX

    # this ensures that this symlinking for lua starts at lib/lua/5.2 and not
    # below that, thus making luarocks work
    (HOMEBREW_PREFIX/"lib/lua/#{V}").mkpath
    (HOMEBREW_PREFIX/"share/lua/#{V}").mkpath

    system "make", "macosx", "INSTALL_TOP=#{prefix}", "INSTALL_MAN=#{man1}"
    system "make", "install", "INSTALL_TOP=#{prefix}", "INSTALL_MAN=#{man1}"

    # Make wrappers that set environment to find correct rocktree.
    (prefix+"bin/lua-#{V}").write wrap_script ("#{V}", "-")
    (prefix+"bin/luac-#{V}").write wrap_script ("#{V}", "-")

    (lib+"lua/#{V}/luarocks-config.lua").write luarocks_cfg_file
    (lib+"pkgconfig/lua#{V}.pc").write pc_file
    (lib+"pkgconfig/lua.pc").make_relative_symlink (lib+"pkgconfig/lua#{V}.pc")
  end

  def pc_file; <<-EOS.undent
    prefix=#{opt_prefix}
    exec_prefix=${prefix}
    libdir=${exec_prefix}/lib
    includedir=${prefix}/include/lua-#{V}

    Name: Lua
    Description: An Extensible Extension Language
    Version: #{version}
    Requires:
    Libs: -L${libdir} -llua.#{V} -lm
    Cflags: -I${includedir}
    EOS
  end

  def luarocks_cfg_file; <<-EOS.undent
    rocks_trees = { "#{HOMEBREW_PREFIX}" }
    variables = {
      LUA = "#{opt_prefix}/bin/lua-#{V}",
      LUA_BINDIR = "#{opt_prefix}/bin",
      LUA_INCDIR = "#{opt_prefix}/include/lua-#{V}",
      LUA_LIBDIR = "#{opt_prefix}/lib",
    }
    EOS
  end

  def wrap_script (suffix, sep = ""); <<-EOS.undent
    #!/bin/sh
    export LUA='#{opt_prefix}/libexec/lua#{sep}#{suffix}'
    export LUAROCKS_CONFIG='#{HOMEBREW_PREFIX}/lib/lua/#{suffix}/luarocks-config.lua'
    eval `"$LUA" '#{HOMEBREW_PREFIX}/bin/luarocks' path 2>/dev/null`
    exec "$LUA" ${1+"$@"}
    EOS
  end
end

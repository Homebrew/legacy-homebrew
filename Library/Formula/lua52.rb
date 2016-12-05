require 'formula'

class Lua52 < Formula
  homepage 'http://www.lua.org/'
  url 'http://www.lua.org/ftp/lua-5.2.2.tar.gz'
  sha1 '0857e41e5579726a4cb96732e80d7aa47165eaf5'

  fails_with :llvm do
    build 2326
    cause "Lua itself compiles with LLVM, but may fail when other software tries to link."
  end

  option 'with-completion', 'Enables advanced readline support'
  option 'with-sigaction', 'Signal handling improvements for interpreter'

  def patches
    p = []
    # Be sure to build a dylib, or else runtime modules will pull in another static copy of liblua = crashy
    # See: https://github.com/mxcl/homebrew/pull/5043
    # Also, take care of versioned file suffixes to support parallel installation with other releases.
    p << 'https://gist.github.com/gvvaughan/5832054/raw/1f1d726cced4f23719de4aef24d965d257d6bbba/lua-5.2-homebrew.diff'
    # completion provided by advanced readline power patch from
    # http://lua-users.org/wiki/LuaPowerPatches
    if build.with? 'completion'
      p << 'http://luajit.org/patches/lua-5.2.0-advanced_readline.patch'
    end
    # sigaction provided by posix signalling power patch from
    # http://lua-users.org/wiki/LuaPowerPatches
    if build.with? 'sigaction'
      p << 'http://lua-users.org/files/wiki_insecure/power_patches/5.2/lua-5.2.2-sig_catch.patch'
    end
    p
  end

  def install
    inreplace 'src/Makefile' do |s|
      # Use our CC/CFLAGS to compile.
      s.remove_make_var! 'CC'
      s.change_make_var! 'CFLAGS', "#{ENV.cflags} -DLUA_COMPAT_ALL $(SYSCFLAGS) $(MYCFLAGS)"
      s.change_make_var! 'MYLDFLAGS', ENV.ldflags
    end

    # Fix path in the config header
    inreplace 'src/luaconf.h', '/usr/local', HOMEBREW_PREFIX

    # this ensures that this symlinking for lua starts at lib/lua/5.2 and not
    # below that, thus making luarocks work
    (HOMEBREW_PREFIX/"lib/lua"/version.to_s.split('.')[0..1].join('.')).mkpath

    system "make", "macosx", "INSTALL_TOP=#{prefix}", "INSTALL_MAN=#{man1}"
    system "make", "install", "INSTALL_TOP=#{prefix}", "INSTALL_MAN=#{man1}"
  end
end

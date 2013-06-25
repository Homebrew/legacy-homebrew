require 'formula'

class Luajit < Formula
  homepage 'http://luajit.org/luajit.html'
  url 'http://luajit.org/download/LuaJIT-2.0.2.tar.gz'
  sha1 'd21426c4fc6ad8888255139039a014f7e28e7300'
  head 'http://luajit.org/git/luajit-2.0.git'

  skip_clean 'lib/lua/5.1', 'share/lua/5.1'

  option "enable-debug", "Build with debugging symbols"

  V = "jit-2.0"

  def install
    # 1 - Remove the '-O2' so we can set Og if needed.  Leave the -fomit part.
    # 2 - Override the hardcoded gcc.
    # 3 - Remove the '-march=i686' so we can set the march in cflags.
    # All three changes should persist and were discussed upstream.
    inreplace 'src/Makefile' do |f|
      f.change_make_var! 'CCOPT', '-fomit-frame-pointer'
      f.change_make_var! 'CC', ENV.cc
      f.change_make_var! 'CCOPT_x86', ''
    end
    # 1 - Remove the micro version from the installed binary name.
    # 2 - Install executable to libexec ready to be called by wrapper script
    inreplace 'Makefile' do |f|
      f.change_make_var! 'INSTALL_TNAME', "lua#{V}"
      f.change_make_var! 'INSTALL_T', '$(DPREFIX)/libexec/$(INSTALL_TNAME)'
    end
    libexec.mkpath                  # needed by 'make install'

    ENV.O2                          # Respect the developer's choice.
    args = ["PREFIX=#{prefix}"]
    if build.include? 'enable-debug' then
      ENV.Og if ENV.compiler == :clang
      args << 'CCDEBUG=-g'
    end

    # this ensures that this symlinking for lua starts at lib/lua/jit-2.0 and not
    # below that, thus making luarocks work
    (HOMEBREW_PREFIX/"lib/lua/#{V}").mkpath

    bldargs = args
    bldargs << 'amalg'
    system 'make', *bldargs
    args << 'install'
    system 'make', *args            # Build requires args during install

    # Make wrapper that sets environment to find correct rocktree.
    (bin+"lua#{V}").write wrap_script

    (lib+"lua/#{V}/luarocks-config.lua").write luarocks_cfg_file
  end

  def luarocks_cfg_file; <<-EOS.undent
    rocks_trees = { "#{HOMEBREW_PREFIX}/lib/luarocks/rocks-#{V}" }
    variables = {
      LUA = "#{opt_prefix}/bin/lua#{V}",
      LUA_BINDIR = "#{opt_prefix}/bin",
      LUA_INCDIR = "#{opt_prefix}/include/lua#{V}",
      LUA_LIBDIR = "#{opt_prefix}/lib",
    }
    EOS
  end

  def wrap_script; <<-EOS.undent
    #!/bin/sh
    export LUA='#{opt_prefix}/libexec/lua#{V}'
    export LUAROCKS_CONFIG='#{HOMEBREW_PREFIX}/lib/lua/#{V}/luarocks-config.lua'
    eval `"$LUA" '#{HOMEBREW_PREFIX}/bin/luarocks' path 2>/dev/null`
    exec "$LUA" ${1+"$@"}
    EOS
  end
end

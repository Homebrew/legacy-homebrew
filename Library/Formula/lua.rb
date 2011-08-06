require 'formula'

class Lua < Formula
  url 'http://www.lua.org/ftp/lua-5.1.4.tar.gz'
  homepage 'http://www.lua.org/'
  md5 'd0870f2de55d59c1c8419f36e8fac150'

  fails_with_llvm "Lua itself compiles with llvm, but may fail when other software tries to link."

  # Skip cleaning both empty folders and bin/libs so external symbols still work.
  skip_clean :all

  def install
    # Apply patch-level 2
    curl "http://www.lua.org/ftp/patch-lua-5.1.4-3", "-O"
    safe_system '/usr/bin/patch', '-d', 'src', '-i', '../patch-lua-5.1.4-3'
    # we could use the patches method if it supported additional arguments (-d in our case)

    # Use our CC/CFLAGS to compile.
    inreplace 'src/Makefile' do |s|
      s.remove_make_var! 'CC'
      s.change_make_var! 'CFLAGS', "#{ENV.cflags} $(MYCFLAGS)"
    end

    # Fix path in the config header
    inreplace 'src/luaconf.h', '/usr/local', HOMEBREW_PREFIX

    # Fix paths in the .pc
    inreplace 'etc/lua.pc' do |s|
      s.gsub! "prefix= /usr/local", "prefix=#{HOMEBREW_PREFIX}"
      s.gsub! "INSTALL_MAN= ${prefix}/man/man1", "INSTALL_MAN= ${prefix}/share/man/man1"
    end

    # this ensures that this symlinking for lua starts at lib/lua/5.1 and not
    # below that, thus making luarocks work
    (HOMEBREW_PREFIX/"lib/lua"/version.split('.')[0..1].join('.')).mkpath

    system "make", "macosx", "INSTALL_TOP=#{prefix}", "INSTALL_MAN=#{man1}"
    system "make", "install", "INSTALL_TOP=#{prefix}", "INSTALL_MAN=#{man1}"

    (lib+"pkgconfig").install 'etc/lua.pc'
  end
end

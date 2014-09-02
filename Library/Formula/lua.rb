require 'formula'

class Lua < Formula
  homepage 'http://www.lua.org/'
  # We repackage the file in the same way Debian does for liblua50-dev, to include a pkg-config file
  url 'https://raw.githubusercontent.com/DomT4/scripts/master/Homebrew_Resources/Lua/lua-5.2.3.tgz'
  sha1 '4212601d1539c17bc7a752ea2ccf34eca5728ef2'

  fails_with :llvm do
    build 2326
    cause "Lua itself compiles with LLVM, but may fail when other software tries to link."
  end

  option 'completion', 'Enables advanced readline support'

  # Be sure to build a dylib, or else runtime modules will pull in another static copy of liblua = crashy
  # See: https://github.com/mxcl/homebrew/pull/5043
  patch :DATA

  # completion provided by advanced readline power patch from
  # http://lua-users.org/wiki/LuaPowerPatches
  patch do
    url "http://luajit.org/patches/lua-5.2.0-advanced_readline.patch"
    sha1 "ca405dbd126bc018980a26c2c766dfb0f82e919e"
  end if build.include? "completion"

  def install

    # Use our CC/CFLAGS to compile.
    inreplace 'src/Makefile' do |s|
      s.remove_make_var! 'CC'
      s.change_make_var! 'CFLAGS', "#{ENV.cflags} -DLUA_COMPAT_ALL $(SYSCFLAGS) $(MYCFLAGS)"
      s.change_make_var! 'MYLDFLAGS', ENV.ldflags
    end

    # Fix path in the config header
    inreplace 'src/luaconf.h', '/usr/local', HOMEBREW_PREFIX

    # Fix paths in the .pc
    inreplace 'etc/lua.pc' do |s|
      s.gsub! "prefix= /usr/local", "prefix=#{HOMEBREW_PREFIX}"
    end

    system "make", "macosx", "INSTALL_TOP=#{prefix}", "INSTALL_MAN=#{man1}"
    system "make", "install", "INSTALL_TOP=#{prefix}", "INSTALL_MAN=#{man1}"

    (lib+"pkgconfig").install 'etc/lua.pc'

    # Fix some software potentially hunting for different pc names.
    ln_s "#{lib}/pkgconfig/lua.pc", "#{lib}/pkgconfig/lua5.2.pc"
    ln_s "#{lib}/pkgconfig/lua.pc", "#{lib}/pkgconfig/lua-5.2.pc"
  end
end

__END__
diff --git a/Makefile b/Makefile
index bd9515f..5940ba9 100644
--- a/Makefile
+++ b/Makefile
@@ -41,7 +41,7 @@ PLATS= aix ansi bsd freebsd generic linux macosx mingw posix solaris
 # What to install.
 TO_BIN= lua luac
 TO_INC= lua.h luaconf.h lualib.h lauxlib.h lua.hpp
-TO_LIB= liblua.a
+TO_LIB= liblua.5.2.3.dylib
 TO_MAN= lua.1 luac.1
 
 # Lua version and release.
@@ -63,6 +63,8 @@ install: dummy
 	cd src && $(INSTALL_DATA) $(TO_INC) $(INSTALL_INC)
 	cd src && $(INSTALL_DATA) $(TO_LIB) $(INSTALL_LIB)
 	cd doc && $(INSTALL_DATA) $(TO_MAN) $(INSTALL_MAN)
+	ln -s -f liblua.5.2.3.dylib $(INSTALL_LIB)/liblua.5.2.dylib
+	ln -s -f liblua.5.2.dylib $(INSTALL_LIB)/liblua.dylib
 
 uninstall:
 	cd src && cd $(INSTALL_BIN) && $(RM) $(TO_BIN)
diff --git a/src/Makefile b/src/Makefile
index 8c9ee67..7f92407 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -28,7 +28,7 @@ MYOBJS=
 
 PLATS= aix ansi bsd freebsd generic linux macosx mingw posix solaris
 
-LUA_A=	liblua.a
+LUA_A=	liblua.5.2.3.dylib
 CORE_O=	lapi.o lcode.o lctype.o ldebug.o ldo.o ldump.o lfunc.o lgc.o llex.o \
 	lmem.o lobject.o lopcodes.o lparser.o lstate.o lstring.o ltable.o \
 	ltm.o lundump.o lvm.o lzio.o
@@ -56,11 +56,12 @@ o:	$(ALL_O)
 a:	$(ALL_A)
 
 $(LUA_A): $(BASE_O)
-	$(AR) $@ $(BASE_O)
-	$(RANLIB) $@
+	$(CC) -dynamiclib -install_name HOMEBREW_PREFIX/lib/liblua.5.2.dylib \
+		-compatibility_version 5.2 -current_version 5.2.3 \
+		-o liblua.5.2.3.dylib $^
 
 $(LUA_T): $(LUA_O) $(LUA_A)
-	$(CC) -o $@ $(LDFLAGS) $(LUA_O) $(LUA_A) $(LIBS)
+	$(CC) -fno-common $(MYLDFLAGS) -o $@ $(LUA_O) $(LUA_A) -L. -llua.5.2.3 $(LIBS)
 
 $(LUAC_T): $(LUAC_O) $(LUA_A)
 	$(CC) -o $@ $(LDFLAGS) $(LUAC_O) $(LUA_A) $(LIBS)
@@ -106,7 +107,7 @@ linux:
 	$(MAKE) $(ALL) SYSCFLAGS="-DLUA_USE_LINUX" SYSLIBS="-Wl,-E -ldl -lreadline"
 
 macosx:
-	$(MAKE) $(ALL) SYSCFLAGS="-DLUA_USE_MACOSX" SYSLIBS="-lreadline" CC=cc
+	$(MAKE) $(ALL) SYSCFLAGS="-DLUA_USE_MACOSX -fno-common" SYSLIBS="-lreadline" CC=cc
 
 mingw:
 	$(MAKE) "LUA_A=lua52.dll" "LUA_T=lua.exe" \

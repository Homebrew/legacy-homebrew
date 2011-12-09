require 'formula'

class Lua < Formula
  url 'http://www.lua.org/ftp/lua-5.1.4.tar.gz'
  homepage 'http://www.lua.org/'
  md5 'd0870f2de55d59c1c8419f36e8fac150'

  fails_with_llvm "Lua itself compiles with LLVM, but may fail when other software tries to link.",
                  :build => 2326

  # Skip cleaning both empty folders and bin/libs so external symbols still work.
  skip_clean :all

  # Be sure to build a dylib, or else runtime modules will pull in another static copy of liblua = crashy
  # See: https://github.com/mxcl/homebrew/pull/5043
  def patches
    DATA
  end


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

__END__
diff --git a/Makefile b/Makefile
index 6e78f66..6b48d2b 100644
--- a/Makefile
+++ b/Makefile
@@ -43,7 +43,7 @@ PLATS= aix ansi bsd freebsd generic linux macosx mingw posix solaris
 # What to install.
 TO_BIN= lua luac
 TO_INC= lua.h luaconf.h lualib.h lauxlib.h ../etc/lua.hpp
-TO_LIB= liblua.a
+TO_LIB= liblua.5.1.4.dylib
 TO_MAN= lua.1 luac.1
 
 # Lua version and release.
@@ -64,6 +64,8 @@ install: dummy
 	cd src && $(INSTALL_DATA) $(TO_INC) $(INSTALL_INC)
 	cd src && $(INSTALL_DATA) $(TO_LIB) $(INSTALL_LIB)
 	cd doc && $(INSTALL_DATA) $(TO_MAN) $(INSTALL_MAN)
+	ln -s -f liblua.5.1.4.dylib $(INSTALL_LIB)/liblua.5.1.dylib
+	ln -s -f liblua.5.1.dylib $(INSTALL_LIB)/liblua.dylib
 
 ranlib:
 	cd src && cd $(INSTALL_LIB) && $(RANLIB) $(TO_LIB)
diff --git a/src/Makefile b/src/Makefile
index e4a3cd6..e35a1b5 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -22,7 +22,7 @@ MYLIBS=
 
 PLATS= aix ansi bsd freebsd generic linux macosx mingw posix solaris
 
-LUA_A=	liblua.a
+LUA_A=	liblua.5.1.4.dylib
 CORE_O=	lapi.o lcode.o ldebug.o ldo.o ldump.o lfunc.o lgc.o llex.o lmem.o \
 	lobject.o lopcodes.o lparser.o lstate.o lstring.o ltable.o ltm.o  \
 	lundump.o lvm.o lzio.o
@@ -48,11 +48,13 @@ o:	$(ALL_O)
 a:	$(ALL_A)
 
 $(LUA_A): $(CORE_O) $(LIB_O)
-	$(AR) $@ $?
-	$(RANLIB) $@
+	$(CC) -dynamiclib -install_name HOMEBREW_PREFIX/lib/liblua.5.1.dylib \
+		-compatibility_version 5.1 -current_version 5.1.4 \
+		-o liblua.5.1.4.dylib $^
 
 $(LUA_T): $(LUA_O) $(LUA_A)
-	$(CC) -o $@ $(MYLDFLAGS) $(LUA_O) $(LUA_A) $(LIBS)
+	$(CC) -fno-common $(MYLDFLAGS) \
+		-o $@ $(LUA_O) $(LUA_A) -L. -llua.5.1.4 $(LIBS)
 
 $(LUAC_T): $(LUAC_O) $(LUA_A)
 	$(CC) -o $@ $(MYLDFLAGS) $(LUAC_O) $(LUA_A) $(LIBS)
@@ -99,7 +101,7 @@ linux:
 	$(MAKE) all MYCFLAGS=-DLUA_USE_LINUX MYLIBS="-Wl,-E -ldl -lreadline -lhistory -lncurses"
 
 macosx:
-	$(MAKE) all MYCFLAGS=-DLUA_USE_LINUX MYLIBS="-lreadline"
+	$(MAKE) all MYCFLAGS="-DLUA_USE_LINUX -fno-common" MYLIBS="-lreadline"
 # use this on Mac OS X 10.3-
 #	$(MAKE) all MYCFLAGS=-DLUA_USE_MACOSX
 

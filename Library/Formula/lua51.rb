require "formula"

class Lua51 < Formula
  # 5.2 is not fully backwards compatible so we must retain 2 Luas for now.
  # The transition has begun. Lua will now become Lua51, and Lua52 will become Lua.
  homepage "http://www.lua.org/"
  url "http://www.lua.org/ftp/lua-5.1.5.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/l/lua5.1/lua5.1_5.1.5.orig.tar.gz"
  sha1 "b3882111ad02ecc6b972f8c1241647905cb2e3fc"

  bottle do
    revision 1
    sha1 "139e0f93e5484c9eb256b65ceaaf05ea43919341" => :yosemite
    sha1 "8f9293404e5acb8cd0aafb772e97eda7b7f06ca2" => :mavericks
    sha1 "50fcc046ae49c44018ca2e88c1634b264e725681" => :mountain_lion
  end

  fails_with :llvm do
    build 2326
    cause "Lua itself compiles with LLVM, but may fail when other software tries to link."
  end

  option :universal
  option "with-completion", "Enables advanced readline support"
  option "without-sigaction", "Revert to ANSI signal instead of improved POSIX sigaction"

  # Be sure to build a dylib, or else runtime modules will pull in another static copy of liblua = crashy
  # See: https://github.com/Homebrew/homebrew/pull/5043
  patch :DATA

  # sigaction provided by posix signalling power patch from
  # http://lua-users.org/wiki/LuaPowerPatches
  patch do
    url "http://lua-users.org/files/wiki_insecure/power_patches/5.1/sig_catch.patch"
    sha1 "19f361f0c590f80fccd033486cbee6c9dc8616c8"
  end if build.with? "sigaction"

  # completion provided by advanced readline power patch from
  # http://lua-users.org/wiki/LuaPowerPatches
  patch do
    url "http://luajit.org/patches/lua-5.1.4-advanced_readline.patch"
    sha1 "3cfe2eb027b51202923d20042ae37f3249508664"
  end if build.with? "completion"

  def install
    ENV.universal_binary if build.universal?

    # Use our CC/CFLAGS to compile.
    inreplace "src/Makefile" do |s|
      s.remove_make_var! "CC"
      s.change_make_var! "CFLAGS", "#{ENV.cflags} $(MYCFLAGS)"
      s.change_make_var! "MYLDFLAGS", ENV.ldflags
      s.sub! "MYCFLAGS_VAL", "-fno-common -DLUA_USE_LINUX"
    end

    # Fix path in the config header
    inreplace "src/luaconf.h", "/usr/local", HOMEBREW_PREFIX

    # Fix paths in the .pc
    inreplace "etc/lua.pc" do |s|
      s.gsub! "prefix= /usr/local", "prefix=#{HOMEBREW_PREFIX}"
      s.gsub! "INSTALL_MAN= ${prefix}/man/man1", "INSTALL_MAN= ${prefix}/share/man/man1"
      s.gsub! "INSTALL_INC= ${prefix}/include", "INSTALL_INC= ${prefix}/include/lua-5.1"
      s.gsub! "includedir=${prefix}/include", "includedir=${prefix}/include/lua-5.1"
      s.gsub! "Libs: -L${libdir} -llua -lm", "Libs: -L${libdir} -llua5.1 -lm"
    end

    system "make", "macosx", "INSTALL_TOP=#{prefix}", "INSTALL_MAN=#{man1}", "INSTALL_INC=#{include}/lua-5.1"
    system "make", "install", "INSTALL_TOP=#{prefix}", "INSTALL_MAN=#{man1}", "INSTALL_INC=#{include}/lua-5.1"

    (lib+"pkgconfig").install "etc/lua.pc"

    # Renaming from Lua to Lua51.
    # Note that the naming must be both lua-version & lua.version.
    # Software can't find the libraries without supporting both the hyphen or full stop.

    mv "#{bin}/lua", "#{bin}/lua-5.1"
    mv "#{bin}/luac", "#{bin}/luac-5.1"
    mv "#{man1}/lua.1", "#{man1}/lua-5.1.1"
    mv "#{man1}/luac.1", "#{man1}/luac-5.1.1"
    mv "#{lib}/pkgconfig/lua.pc", "#{lib}/pkgconfig/lua5.1.pc"
    ln_s "#{lib}/pkgconfig/lua5.1.pc", "#{lib}/pkgconfig/lua-5.1.pc"
    ln_s "#{include}/lua-5.1", "#{include}/lua5.1"
    ln_s "#{bin}/lua-5.1", "#{bin}/lua5.1"
    ln_s "#{bin}/luac-5.1", "#{bin}/luac5.1"
  end

  test do
    system "#{bin}/lua5.1", "-e", "print ('Ducks are cool')"
  end
end

__END__
diff --git a/Makefile b/Makefile
index 209a132..9387b09 100644
--- a/Makefile
+++ b/Makefile
@@ -43,7 +43,7 @@ PLATS= aix ansi bsd freebsd generic linux macosx mingw posix solaris
 # What to install.
 TO_BIN= lua luac
 TO_INC= lua.h luaconf.h lualib.h lauxlib.h ../etc/lua.hpp
-TO_LIB= liblua.a
+TO_LIB= liblua.5.1.5.dylib
 TO_MAN= lua.1 luac.1

 # Lua version and release.
@@ -64,6 +64,8 @@ install: dummy
	cd src && $(INSTALL_DATA) $(TO_INC) $(INSTALL_INC)
	cd src && $(INSTALL_DATA) $(TO_LIB) $(INSTALL_LIB)
	cd doc && $(INSTALL_DATA) $(TO_MAN) $(INSTALL_MAN)
+	ln -s -f liblua.5.1.5.dylib $(INSTALL_LIB)/liblua.5.1.dylib
+	ln -s -f liblua.5.1.dylib $(INSTALL_LIB)/liblua5.1.dylib

 ranlib:
	cd src && cd $(INSTALL_LIB) && $(RANLIB) $(TO_LIB)
diff --git a/src/Makefile b/src/Makefile
index e0d4c9f..4477d7b 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -22,7 +22,7 @@ MYLIBS=

 PLATS= aix ansi bsd freebsd generic linux macosx mingw posix solaris

-LUA_A=	liblua.a
+LUA_A=	liblua.5.1.5.dylib
 CORE_O=	lapi.o lcode.o ldebug.o ldo.o ldump.o lfunc.o lgc.o llex.o lmem.o \
	lobject.o lopcodes.o lparser.o lstate.o lstring.o ltable.o ltm.o  \
	lundump.o lvm.o lzio.o
@@ -48,11 +48,13 @@ o:	$(ALL_O)
 a:	$(ALL_A)

 $(LUA_A): $(CORE_O) $(LIB_O)
-	$(AR) $@ $(CORE_O) $(LIB_O)	# DLL needs all object files
-	$(RANLIB) $@
+	$(CC) -dynamiclib -install_name HOMEBREW_PREFIX/lib/liblua.5.1.dylib \
+		-compatibility_version 5.1 -current_version 5.1.5 \
+		-o liblua.5.1.5.dylib $^

 $(LUA_T): $(LUA_O) $(LUA_A)
-	$(CC) -o $@ $(MYLDFLAGS) $(LUA_O) $(LUA_A) $(LIBS)
+	$(CC) -fno-common $(MYLDFLAGS) \
+		-o $@ $(LUA_O) $(LUA_A) -L. -llua.5.1.5 $(LIBS)

 $(LUAC_T): $(LUAC_O) $(LUA_A)
	$(CC) -o $@ $(MYLDFLAGS) $(LUAC_O) $(LUA_A) $(LIBS)
@@ -99,7 +101,7 @@ linux:
	$(MAKE) all MYCFLAGS=-DLUA_USE_LINUX MYLIBS="-Wl,-E -ldl -lreadline -lhistory -lncurses"

 macosx:
-	$(MAKE) all MYCFLAGS=-DLUA_USE_LINUX MYLIBS="-lreadline"
+	$(MAKE) all MYCFLAGS="MYCFLAGS_VAL" MYLIBS="-lreadline"
 # use this on Mac OS X 10.3-
 #	$(MAKE) all MYCFLAGS=-DLUA_USE_MACOSX

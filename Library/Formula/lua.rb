require 'brewkit'

class Lua <Formula
  @url='http://www.lua.org/ftp/lua-5.1.4.tar.gz'
  @homepage='http://www.lua.org/'
  @md5='d0870f2de55d59c1c8419f36e8fac150'
  
  def patches
    DATA
  end

  def install
    inreplace 'Makefile', '/usr/local', prefix
    inreplace 'src/luaconf.h', '/usr/local', prefix
    inreplace 'etc/lua.pc', '/usr/local', prefix

    inreplace 'Makefile', 'man/man1', 'share/man/man1'
    inreplace 'etc/lua.pc', 'man/man1', 'share/man/man1'
    inreplace 'src/luaconf.h', '/usr/local', HOMEBREW_PREFIX

    ENV["CFLAGS"] += " -DLUA_USE_LINUX"

    system "make macosx"
    system "make install"
  end
end


# TODO honestly maybe this is better as it was before, ie. a gist. It's long
# and potentially more useful to other people as a gist.
__END__
diff -Naur lua-5.1.4/Makefile lua-5.1.4-2/Makefile
--- lua-5.1.4/Makefile	2008-08-11 18:40:48.000000000 -0600
+++ lua-5.1.4-2/Makefile	2009-09-04 16:30:22.000000000 -0600
@@ -13,7 +13,7 @@
 INSTALL_BIN= $(INSTALL_TOP)/bin
 INSTALL_INC= $(INSTALL_TOP)/include
 INSTALL_LIB= $(INSTALL_TOP)/lib
-INSTALL_MAN= $(INSTALL_TOP)/man/man1
+INSTALL_MAN= $(INSTALL_TOP)/share/man/man1
 #
 # You probably want to make INSTALL_LMOD and INSTALL_CMOD consistent with
 # LUA_ROOT, LUA_LDIR, and LUA_CDIR in luaconf.h (and also with etc/lua.pc).
diff -Naur lua-5.1.4/etc/Makefile lua-5.1.4-2/etc/Makefile
--- lua-5.1.4/etc/Makefile	2006-02-07 12:09:30.000000000 -0700
+++ lua-5.1.4-2/etc/Makefile	2009-09-04 16:49:51.000000000 -0600
@@ -7,10 +7,9 @@
 SRC= $(TOP)/src
 TST= $(TOP)/test
 
-CC= gcc
-CFLAGS= -O2 -Wall -I$(INC) $(MYCFLAGS)
+CC= gcc-4.2
 MYCFLAGS= 
-MYLDFLAGS= -Wl,-E
+MYLDFLAGS= $(LDFLAGS) -Wl,-E
 MYLIBS= -lm
 #MYLIBS= -lm -Wl,-E -ldl -lreadline -lhistory -lncurses
 RM= rm -f
@@ -19,7 +18,7 @@
 	@echo 'Please choose a target: min noparser one strict clean'
 
 min:	min.c
-	$(CC) $(CFLAGS) $@.c -L$(LIB) -llua $(MYLIBS)
+	$(CC) $(CFLAGS) -I$(INC) $@.c -L$(LIB) -llua $(MYLIBS)
 	echo 'print"Hello there!"' | ./a.out
 
 noparser: noparser.o
@@ -29,7 +28,7 @@
 	-./a.out -e'a=1'
 
 one:
-	$(CC) $(CFLAGS) all.c $(MYLIBS)
+	$(CC) $(CFLAGS) -I$(INC) all.c $(MYLIBS)
 	./a.out $(TST)/hello.lua
 
 strict:
diff -Naur lua-5.1.4/etc/lua.pc lua-5.1.4-2/etc/lua.pc
--- lua-5.1.4/etc/lua.pc	2008-08-08 06:46:11.000000000 -0600
+++ lua-5.1.4-2/etc/lua.pc	2009-09-04 16:30:35.000000000 -0600
@@ -12,7 +12,7 @@
 INSTALL_BIN= ${prefix}/bin
 INSTALL_INC= ${prefix}/include
 INSTALL_LIB= ${prefix}/lib
-INSTALL_MAN= ${prefix}/man/man1
+INSTALL_MAN= ${prefix}/share/man/man1
 INSTALL_LMOD= ${prefix}/share/lua/${V}
 INSTALL_CMOD= ${prefix}/lib/lua/${V}
 
diff -Naur lua-5.1.4/src/Makefile lua-5.1.4-2/src/Makefile
--- lua-5.1.4/src/Makefile	2008-01-19 12:37:58.000000000 -0700
+++ lua-5.1.4-2/src/Makefile	2009-09-04 16:49:18.000000000 -0600
@@ -7,15 +7,14 @@
 # Your platform. See PLATS for possible values.
 PLAT= none
 
-CC= gcc
-CFLAGS= -O2 -Wall $(MYCFLAGS)
+CC= gcc-4.2
 AR= ar rcu
 RANLIB= ranlib
 RM= rm -f
 LIBS= -lm $(MYLIBS)
 
 MYCFLAGS=
-MYLDFLAGS=
+MYLDFLAGS= $(LDFLAGS)
 MYLIBS=
 
 # == END OF USER SETTINGS. NO NEED TO CHANGE ANYTHING BELOW THIS LINE =========
@@ -52,10 +51,10 @@
 	$(RANLIB) $@
 
 $(LUA_T): $(LUA_O) $(LUA_A)
-	$(CC) -o $@ $(MYLDFLAGS) $(LUA_O) $(LUA_A) $(LIBS)
+	$(CC) $(CFLAGS) -o $@ $(MYLDFLAGS) $(LUA_O) $(LUA_A) $(LIBS)
 
 $(LUAC_T): $(LUAC_O) $(LUA_A)
-	$(CC) -o $@ $(MYLDFLAGS) $(LUAC_O) $(LUA_A) $(LIBS)
+	$(CC) $(CFLAGS) -o $@ $(MYLDFLAGS) $(LUAC_O) $(LUA_A) $(LIBS)
 
 clean:
 	$(RM) $(ALL_T) $(ALL_O)

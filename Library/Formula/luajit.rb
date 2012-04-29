require 'formula'

class Luajit < Formula
  homepage 'http://luajit.org/luajit.html'
  url 'http://luajit.org/download/LuaJIT-2.0.0-beta9.tar.gz'
  md5 'e7e03e67e2550817358bc28b44270c6d'

  head 'http://luajit.org/git/luajit-2.0.git'

  # Skip cleaning both empty folders and bin/libs so external symbols still work.
  skip_clean :all

  def options
    [["--enable-debug", "Build with debugging symbols."]]
  end

  def patches
    unless ARGV.build_head? then
      # Remove all patches at 2.0.0-beta10.  They are fixed in HEAD.
      # Patch 1: Hotfix is recommended by the LuaJIT developers.
      # Patch 2: Fixes no /usr/include/unwind.h on Snow Leopard for Clang.
      # DATA fixes build error with clang, no -dumpspecs options. Also removes
      # the instruction to use sudo to symlink luajit.  We do that already.
      [ "http://luajit.org/download/beta9_hotfix1.patch",
        "http://repo.or.cz/w/luajit-2.0.git/patch/018792452ecdcaeff9362e4238004420665b450b",
        DATA ]
    end
  end

  def install
    # 1 - Remove the '-O2' so we can set Og if needed.  Leave the -fomit part.
    # 2 - Override the hardcoded gcc.
    # 3 - Remove the '-march=i686' so we can set the march in cflags.
    # All three changes should persist and were discussed upstream.
    inreplace 'src/Makefile' do |f|
      f.change_make_var! 'CCOPT', '-fomit-frame-pointer'
      f.change_make_var! 'CC', ENV.cc
      f.change_make_var! 'CCOPT_X86', ''
    end

    ENV.O2                          # Respect the developer's choice.
    args = [ "PREFIX=#{prefix}" ]
    if ARGV.include? '--enable-debug' then
      ENV.Og if ENV.compiler == :clang
      args << 'CCDEBUG=-g'
    end

    bldargs = args
    bldargs << 'amalg'
    system 'make', *bldargs
    args << 'install'
    system 'make', *args            # Build requires args during install

    # Non-versioned symlink
    if ARGV.build_head?
      version = "2.0.0-beta9"
    else
      version = @version
    end
    ln_s bin+"luajit-#{version}", bin+"luajit"
  end
end

__END__
--- a/src/Makefile
+++ b/src/Makefile
@@ -219,10 +219,6 @@
 TARGET_ASHLDFLAGS= $(LDOPTIONS) $(TARGET_XSHLDFLAGS) $(TARGET_FLAGS) $(TARGET_SHLDFLAGS)
 TARGET_ALIBS= $(TARGET_XLIBS) $(LIBS) $(TARGET_LIBS)
 
-ifneq (,$(findstring stack-protector,$(shell $(TARGET_CC) -dumpspecs)))
-  TARGET_XCFLAGS+= -fno-stack-protector
-endif
-
 TARGET_TESTARCH=$(shell $(TARGET_CC) $(TARGET_ACFLAGS) -E lj_arch.h -dM)
 ifneq (,$(findstring LJ_TARGET_X64 ,$(TARGET_TESTARCH)))
   TARGET_CCARCH= x64
@@ -283,9 +279,12 @@
   TARGET_DYNXLDOPTS=
 else
 ifeq (Darwin,$(TARGET_SYS))
-  export MACOSX_DEPLOYMENT_TARGET=10.4
+  ifeq (,$(MACOSX_DEPLOYMENT_TARGET))
+    export MACOSX_DEPLOYMENT_TARGET=10.4
+  endif
   TARGET_STRIP+= -x
   TARGET_AR+= 2>/dev/null
+  TARGET_XCFLAGS+= -fno-stack-protector
   TARGET_XSHLDFLAGS= -dynamiclib -single_module -undefined dynamic_lookup -fPIC
   TARGET_DYNXLDOPTS=
   TARGET_XSHLDFLAGS+= -install_name $(TARGET_DYLIBPATH) -compatibility_version $(MAJVER).$(MINVER) -current_version $(MAJVER).$(MINVER).$(RELVER)
@@ -297,10 +296,14 @@
 ifeq (iOS,$(TARGET_SYS))
   TARGET_STRIP+= -x
   TARGET_AR+= 2>/dev/null
+  TARGET_XCFLAGS+= -fno-stack-protector
   TARGET_XSHLDFLAGS= -dynamiclib -single_module -undefined dynamic_lookup -fPIC
   TARGET_DYNXLDOPTS=
   TARGET_XSHLDFLAGS+= -install_name $(TARGET_DYLIBPATH) -compatibility_version $(MAJVER).$(MINVER) -current_version $(MAJVER).$(MINVER).$(RELVER)
 else
+  ifneq (,$(findstring stack-protector,$(shell $(TARGET_CC) -dumpspecs)))
+    TARGET_XCFLAGS+= -fno-stack-protector
+  endif
   ifneq (SunOS,$(TARGET_SYS))
     TARGET_XLDFLAGS+= -Wl,-E
   endif
--- a/Makefile	2012-03-31 11:23:39.000000000 -0700
+++ b/Makefile	2012-03-31 11:24:20.000000000 -0700
@@ -116,11 +116,6 @@
 	cd lib && $(INSTALL_F) $(FILES_JITLIB) $(INSTALL_JITLIB)
 	@echo "==== Successfully installed LuaJIT $(VERSION) to $(PREFIX) ===="
 	@echo ""
-	@echo "Note: the beta releases deliberately do NOT install a symlink for luajit"
-	@echo "You can do this now by running this command (with sudo):"
-	@echo ""
-	@echo "  $(SYMLINK) $(INSTALL_TNAME) $(INSTALL_TSYM)"
-	@echo ""
 
 ##############################################################################
 

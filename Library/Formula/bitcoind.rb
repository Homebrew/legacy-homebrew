require 'formula'

class Bitcoind < Formula
  url 'https://github.com/bitcoin/bitcoin/tarball/v0.3.23'
  version '0.3.23'
  homepage 'http://www.bitcoin.org/'
  md5 '8a8edec8c2581ac6e263cc78d4ec0914'

  depends_on 'boost'
  depends_on 'berkeley-db'
  
  def options
     [
       ["--no-keg-only", "Builds Bitcoin without `keg_only` mode, linking it to /usr/local"],
     ]
  end
  
  if !ARGV.include?('--no-keg-only')
    keg_only "bitcoind requires version db-4.8 of Berkely-DB. See https://github.com/bitcoin/bitcoin/blob/master/doc/build-osx.txt"
  end

  def patches
    # Fixes for the makefile for Mac OS 10.6
    DATA
  end

  def install
    cd "src/" do
        system "make -f makefile.osx bitcoind"
        bin.install "bitcoind"
    end
  end

  def caveats; <<-EOS.undent
    Bitcoin depends on berkeley-db 4.x, but Homebrew provides version 5.x,
    which doesn't work. To work around this, do:
      $ brew install https://github.com/adamv/homebrew-alt/raw/master/versions/berkeley-db4.rb --without-java
      $ brew install boost
      $ brew install --ignore-dependencies bitcoind
      
    Due to this older dependency this brew is `keg_only` by default and will not 
    link the compiled program for you. If you wish to link the program use the
    `--no-keg-only` flag when you install:
      $ brew install --ignore-dependencies --no-keg-only bitcoind 
    EOS
  end

end

__END__
diff --git a/src/makefile.osx b/src/makefile.osx
index 4836ea3..18a6b7c 100644
--- a/src/makefile.osx
+++ b/src/makefile.osx
@@ -6,7 +6,7 @@
 # Laszlo Hanyecz (solar@heliacal.net)
 
 CXX=llvm-g++
-DEPSDIR=/Users/macosuser/bitcoin/deps
+DEPSDIR=/usr/local
 
 INCLUDEPATHS= \
  -I"$(DEPSDIR)/include"
@@ -14,24 +14,22 @@ INCLUDEPATHS= \
 LIBPATHS= \
  -L"$(DEPSDIR)/lib"
 
-WXLIBS=$(shell $(DEPSDIR)/bin/wx-config --libs --static)
-
 USE_UPNP:=0
 
 LIBS= -dead_strip \
- $(DEPSDIR)/lib/libdb_cxx-4.8.a \
- $(DEPSDIR)/lib/libboost_system.a \
- $(DEPSDIR)/lib/libboost_filesystem.a \
- $(DEPSDIR)/lib/libboost_program_options.a \
- $(DEPSDIR)/lib/libboost_thread.a \
- $(DEPSDIR)/lib/libssl.a \
- $(DEPSDIR)/lib/libcrypto.a 
+ -ldb_cxx \
+ -lboost_system-mt \
+ -lboost_filesystem-mt \
+ -lboost_program_options-mt \
+ -lboost_thread-mt \
+ -lssl \
+ -lcrypto 
 
-DEFS=$(shell $(DEPSDIR)/bin/wx-config --cxxflags) -D__WXMAC_OSX__ -DNOPCH -DMSG_NOSIGNAL=0 -DUSE_SSL
+DEFS= -D__WXMAC_OSX__ -DNOPCH -DMSG_NOSIGNAL=0 -DUSE_SSL -DMSG_NOSIGNAL=0 -DUSE_SSL
 
 DEBUGFLAGS=-g -DwxDEBUG_LEVEL=0
 # ppc doesn't work because we don't support big-endian
-CFLAGS=-mmacosx-version-min=10.5 -arch i386 -arch x86_64 -O3 -Wno-invalid-offsetof -Wformat $(DEBUGFLAGS) $(DEFS) $(INCLUDEPATHS)
+CFLAGS=-mmacosx-version-min=10.6 -arch x86_64 -O3 -Wno-invalid-offsetof -Wformat $(DEBUGFLAGS) $(DEFS) $(INCLUDEPATHS)
 HEADERS=headers.h strlcpy.h serialize.h uint256.h util.h key.h bignum.h base58.h \
     script.h db.h net.h irc.h main.h rpc.h uibase.h ui.h noui.h init.h
 
@@ -47,8 +45,8 @@ OBJS= \
     cryptopp/obj/sha.o \
     cryptopp/obj/cpu.o
 
-ifdef USE_UPNP
-	LIBS += $(DEPSDIR)/lib/libminiupnpc.a
+ifeq (USE_UPNP, 1)
+	LIBS += --enable-upnp
 	DEFS += -DUSE_UPNP=$(USE_UPNP)
 endif
 	

require 'formula'

class StockfishBook < Formula
  url 'http://cl.ly/3x333m0G173F/download/stockfish-231-book.zip'
  sha1 '8206b99ceb803b23980f1cb30ea41a450e21ae03'
end

class Stockfish < Formula
  homepage 'http://stockfishchess.org/'
  url 'https://github.com/mcostalba/Stockfish/archive/sf_2.3.1.zip'
  version '231'
  sha1 '4d3cbda3dbe29dd51b3bdc2a3cefd20c68992050'

  def install
    cd('src')
    system "make", "clean"
    system "make", "profile-build", "ARCH=osx-x86-64", "COMP=clang"
    system "make", "testrun"
    system "make", "-e" , "PREFIX=#{prefix}", "install"

    ohai 'Installing opening book ...'
    StockfishBook.new.brew { bin.install Dir['*'] }
  end

  def patches
    DATA
  end

  def test
    system "'quit' | stockfish"
  end
end

__END__
diff --git a/src/Makefile b/src/Makefile
index 2ad22de..1d89ce6 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -466,13 +466,13 @@ gcc-profile-prepare:
 gcc-profile-make:
 	$(MAKE) ARCH=$(ARCH) COMP=$(COMP) \
 	EXTRACXXFLAGS='-fprofile-generate' \
-	EXTRALDFLAGS='-lgcov' \
+	EXTRALDFLAGS='' \
 	all

 gcc-profile-use:
 	$(MAKE) ARCH=$(ARCH) COMP=$(COMP) \
 	EXTRACXXFLAGS='-fprofile-use' \
-	EXTRALDFLAGS='-lgcov' \
+	EXTRALDFLAGS='' \
 	all

 gcc-profile-clean:

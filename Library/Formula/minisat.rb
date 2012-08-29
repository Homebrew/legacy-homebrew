require 'formula'

class Minisat < Formula
  url 'https://github.com/niklasso/minisat/tarball/master'
  #url 'https://github.com/niklasso/minisat/tarball/releases/2.2.0'
  homepage 'http://minisat.se'
  #md5 '2274977506042714811968afca01b68d'
  version 'master'

  def patches
	DATA
  end

  def install
	system "cmake CMakeLists.txt"
	system "make"
	bin.install 'minisat_simp' => 'minisat'
	lib.install Dir['libminisat.*']
	minisat = include + 'minisat'
	core = minisat + 'core'
	mtl = minisat + 'mtl'
	simp = minisat + 'simp'
	utils = minisat + 'utils'
	core.install Dir['minisat/core/*.h']
	mtl.install Dir['minisat/mtl/*.h']
	simp.install Dir['minisat/simp/*.h']
	utils.install Dir['minisat/utils/*.h']
  end

end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index ae4da00..ecbb30f 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -68,7 +68,7 @@ set_target_properties(minisat-lib-shared
	 VERSION ${MINISAT_VERSION}
	 SOVERSION ${MINISAT_SOVERSION})

-set_target_properties(minisat_simp       PROPERTIES OUTPUT_NAME "minisat")
+set_target_properties(minisat_simp       PROPERTIES OUTPUT_NAME "minisat_simp")

 #--------------------------------------------------------------------------------------------------
 # Installation targets:

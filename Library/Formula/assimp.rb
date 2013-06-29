require 'formula'

class Assimp < Formula
  homepage 'http://assimp.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/assimp/assimp-3.0/assimp--3.0.1270-source-only.zip'
  sha1 'e80a3a4326b649ed6585c0ce312ed6dd68942834'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def patches
    #makes assimp3 compile with clang
    #reported upstream http://sourceforge.net/p/assimp/discussion/817654/thread/381fa18a
    #and http://sourceforge.net/p/assimp/patches/43/
    DATA
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 3d5833e..d0cdd7c 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -2,7 +2,7 @@ cmake_minimum_required( VERSION 2.6 )
 PROJECT( Assimp )
 
 # Define here the needed parameters
-set (ASSIMP_SV_REVISION 1264)
+set (ASSIMP_SV_REVISION 255)
 set (ASSIMP_VERSION_MAJOR 3)
 set (ASSIMP_VERSION_MINOR 0)
 set (ASSIMP_VERSION_PATCH ${ASSIMP_SV_REVISION}) # subversion revision?
diff --git a/code/STEPFile.h b/code/STEPFile.h
index f958956..510e051 100644
--- a/code/STEPFile.h
+++ b/code/STEPFile.h
@@ -195,13 +195,13 @@ namespace STEP {
 			// conversion support.
 			template <typename T>
 			const T& ResolveSelect(const DB& db) const {
-				return Couple<T>(db).MustGetObject(To<EXPRESS::ENTITY>())->To<T>();
+				return Couple<T>(db).MustGetObject(To<EXPRESS::ENTITY>())->template To<T>();
 			}
 
 			template <typename T>
 			const T* ResolveSelectPtr(const DB& db) const {
 				const EXPRESS::ENTITY* e = ToPtr<EXPRESS::ENTITY>();
-				return e?Couple<T>(db).MustGetObject(*e)->ToPtr<T>():(const T*)0;
+				return e?Couple<T>(db).MustGetObject(*e)->template ToPtr<T>():(const T*)0;
 			}
 
 		public:

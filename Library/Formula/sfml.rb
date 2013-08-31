require 'formula'

class Sfml < Formula
  homepage 'http://www.sfml-dev.org/'
  url 'http://www.sfml-dev.org/download/sfml/2.1/SFML-2.1-sources.zip'
  sha1 'c27bdffdc4bedb5f6a20db03ceca715d42aa5752'

  depends_on 'cmake' => :build
  depends_on 'libsndfile'
  depends_on 'jpeg'
  depends_on 'glew'
  depends_on 'freetype'

  # option :universal
  # Universal is not supported for now because of GLEW.

  def patches
    # We need to patch CMakeLists.txt so it will ignore extlibs.
    DATA
  end

  def install
    ENV.universal_binary if build.include? 'universal'
    # Let's make sure cmake will only find brewed or system libs.
    system "rm", "-rf", "./extlibs"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 4d977d5..b985fb2 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -199,8 +199,6 @@ if(WINDOWS)
         install(FILES extlibs/bin/x64/openal32.dll DESTINATION bin)
     endif()
 elseif(MACOSX)
-    install(DIRECTORY extlibs/libs-osx/Frameworks/sndfile.framework DESTINATION ${CMAKE_INSTALL_FRAMEWORK_PREFIX})
-    install(DIRECTORY extlibs/libs-osx/Frameworks/freetype.framework DESTINATION ${CMAKE_INSTALL_FRAMEWORK_PREFIX})
 
     if(SFML_INSTALL_XCODE4_TEMPLATES)
         install(DIRECTORY tools/xcode/templates/SFML DESTINATION /Library/Developer/Xcode/Templates)

require 'formula'

class Portmidi < Formula
  homepage 'http://sourceforge.net/apps/trac/portmedia/wiki/portmidi'
  url 'http://downloads.sourceforge.net/project/portmedia/portmidi/217/portmidi-src-217.zip'
  sha1 'f45bf4e247c0d7617deacd6a65d23d9fddae6117'

  option 'with-java', 'Build java based app and bindings. You need the Java SDK for this.'
  option 'with-python', 'Build the pyportmidi python module.'

  depends_on 'cmake' => :build
  depends_on 'Cython' => :python if build.include? 'with-python'

  def patches
    # Avoid that the Makefile.osx builds the java app and fails because: fatal error: 'jni.h' file not found
    # Since 217 the Makefile.osx includes pm_common/CMakeLists.txt wich builds the Java app
    DATA unless build.include? 'with-java'
  end

  def install
    inreplace 'pm_mac/Makefile.osx', 'PF=/usr/local', "PF=#{prefix}"

    # need to create include/lib directories since make won't create them itself
    include.mkpath
    lib.mkpath

    # Fix outdated SYSROOT to avoid: No rule to make target `/Developer/SDKs/MacOSX10.5.sdk/System/Library/Frameworks/CoreAudio.framework', needed by `latency'.  Stop.
    inreplace 'pm_common/CMakeLists.txt', 'set(CMAKE_OSX_SYSROOT /Developer/SDKs/MacOSX10.5.sdk CACHE', "set(CMAKE_OSX_SYSROOT /#{MacOS.sdk_path} CACHE"

    system 'make -f pm_mac/Makefile.osx'
    system 'make -f pm_mac/Makefile.osx install'

    if build.include? 'with-python'
      # In order to install into the Cellar, the dir must exist and be in the
      # PYTHONPATH.
      temp_site_packages = lib/which_python/'site-packages'
      mkdir_p temp_site_packages
      ENV['PYTHONPATH'] = temp_site_packages

      args = [
        "--no-user-cfg",
        "--verbose",
        "install",
        "--force",
        "--install-scripts=#{bin}",
        "--install-lib=#{temp_site_packages}",
        "--install-data=#{share}",
        "--install-headers=#{include}",
      ]
      cd 'pm_python' do
        # There is no longer a CHANGES.txt or TODO.txt.
        inreplace 'setup.py', "CHANGES = open('CHANGES.txt').read()", 'CHANGES = ""'
        inreplace 'setup.py', "TODO = open('TODO.txt').read()", 'TODO = ""'
        # Provide correct dirs (that point into the Cellar)
        ENV.append 'CFLAGS', "-I#{include}"
        ENV.append 'LDFLAGS', "-L#{lib}"
        system "python", "-s", "setup.py", *args
      end
    end
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end

__END__
diff --git a/pm_common/CMakeLists.txt b/pm_common/CMakeLists.txt
index e171047..b010c35 100644
--- a/pm_common/CMakeLists.txt
+++ b/pm_common/CMakeLists.txt
@@ -112,14 +112,9 @@ target_link_libraries(portmidi-static ${PM_NEEDED_LIBS})
 # define the jni library
 include_directories(${JAVA_INCLUDE_PATHS})

-set(JNISRC ${LIBSRC} ../pm_java/pmjni/pmjni.c)
-add_library(pmjni SHARED ${JNISRC})
-target_link_libraries(pmjni ${JNI_EXTRA_LIBS})
-set_target_properties(pmjni PROPERTIES EXECUTABLE_EXTENSION "jnilib")
-
 # install the libraries (Linux and Mac OS X command line)
 if(UNIX)
-  INSTALL(TARGETS portmidi-static pmjni
+  INSTALL(TARGETS portmidi-static
     LIBRARY DESTINATION /usr/local/lib
     ARCHIVE DESTINATION /usr/local/lib)
 # .h files installed by pm_dylib/CMakeLists.txt, so don't need them here

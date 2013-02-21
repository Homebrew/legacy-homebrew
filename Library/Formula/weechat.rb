require 'formula'

class Weechat < Formula
  homepage 'http://www.weechat.org'
  url 'http://www.weechat.org/files/src/weechat-0.3.9.2.tar.bz2'
  sha1 '64147c88426c240d5d33c65755c729ed2c435aeb'

  depends_on 'cmake' => :build
  depends_on 'gettext'
  depends_on 'gnutls'
  depends_on 'libgcrypt'
  depends_on 'guile' if build.include? 'guile'
  depends_on 'aspell' if build.include? 'aspell'
  depends_on 'lua' if build.include? 'lua'

  option 'lua', 'Build the lua module'
  option 'perl', 'Build the perl module'
  option 'ruby', 'Build the ruby module'
  option 'guile', 'Build the guile module'
  option 'python', 'Build the python module (requires framework Python)'
  option 'aspell', 'Build the aspell module that checks your spelling'

  def patches
    # Fixes bug #38321: The charset plugin doesn't build on OS X
    # https://savannah.nongnu.org/bugs/index.php?38321
    # Patch incorporated upstream; should be included in the next release
    DATA
  end

  def install
    # Remove all arch flags from the PERL_*FLAGS as we specify them ourselves.
    # This messes up because the system perl is a fat binary with 32, 64 and PPC
    # compiles, but our deps don't have that. Remove at v0.3.8, fixed in HEAD.
    archs = %W[-arch ppc -arch i386 -arch x86_64].join('|')
    inreplace  "src/plugins/perl/CMakeLists.txt",
      'IF(PERL_FOUND)',
      'IF(PERL_FOUND)' +
      %Q{\n  STRING(REGEX REPLACE "#{archs}" "" PERL_CFLAGS "${PERL_CFLAGS}")} +
      %Q{\n  STRING(REGEX REPLACE "#{archs}" "" PERL_LFLAGS "${PERL_LFLAGS}")}

    # FindPython.cmake queries the Python variable LINKFORSHARED which contains
    # a path that only exists during Python install when using HB framework
    # Python.  So remove that and use what's common in every install of Python,
    # namely -u _PyMac_Error.  Without the invalid path, it links okay.
    # Because Macports and Apple change LINKFORSHARED but HB does not, this
    # will have to persist, and it's not reported upstream.  Fixes the error
    #   no such file or directory: 'Python.framework/Versions/2.7/Python'
    inreplace 'src/plugins/python/CMakeLists.txt',
      '${PYTHON_LFLAGS}', '-u _PyMac_Error'

    args = std_cmake_args + %W[
      -DPREFIX=#{prefix}
      -DENABLE_GTK=OFF
    ]
    args << '-DENABLE_LUA=OFF'    unless build.include? 'lua'
    args << '-DENABLE_PERL=OFF'   unless build.include? 'perl'
    args << '-DENABLE_RUBY=OFF'   unless build.include? 'ruby'
    args << '-DENABLE_PYTHON=OFF' unless build.include? 'python'
    args << '-DENABLE_ASPELL=OFF' unless build.include? 'aspell'
    args << '-DENABLE_GUILE=OFF'  unless build.include? 'guile' and \
                                         Formula.factory('guile').linked_keg.exist?
    args << '..'

    mkdir 'build' do
      system 'cmake', *args
      system 'make install'
    end
  end

  def caveats; <<-EOS.undent
      Weechat can depend on Aspell if you choose the --aspell option, but
      Aspell should be installed manually before installing Weechat so that
      you can choose the dictionaries you want.  If Aspell was installed
      automatically as part of weechat, there won't be any dictionaries.
    EOS
  end
end

__END__
diff --git a/cmake/FindIconv.cmake b/cmake/FindIconv.cmake
index c077ba0..6622ea3 100644
--- a/cmake/FindIconv.cmake
+++ b/cmake/FindIconv.cmake
@@ -49,10 +49,11 @@ FIND_LIBRARY(ICONV_LIBRARY
 IF(ICONV_INCLUDE_PATH)
   IF(ICONV_LIBRARY)
     STRING(REGEX REPLACE "/[^/]*$" "" ICONV_LIB_PATH "${ICONV_LIBRARY}")
-    CHECK_LIBRARY_EXISTS(iconv libiconv_open ${ICONV_LIB_PATH} ICONV_FOUND)
-    IF(NOT ICONV_FOUND)
-      CHECK_LIBRARY_EXISTS(iconv iconv_open ${ICONV_LIB_PATH} ICONV_FOUND)
-    ENDIF(NOT ICONV_FOUND)
+    CHECK_LIBRARY_EXISTS(iconv libiconv_open ${ICONV_LIB_PATH} LIBICONV_OPEN_FOUND)
+    CHECK_LIBRARY_EXISTS(iconv iconv_open ${ICONV_LIB_PATH} ICONV_OPEN_FOUND)
+    IF (LIBICONV_OPEN_FOUND OR ICONV_OPEN_FOUND)
+       SET(ICONV_FOUND TRUE)
+    ENDIF (LIBICONV_OPEN_FOUND OR ICONV_OPEN_FOUND)
   ELSE(ICONV_LIBRARY)
     CHECK_FUNCTION_EXISTS(iconv_open ICONV_FOUND)
   ENDIF(ICONV_LIBRARY)

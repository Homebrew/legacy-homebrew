require 'formula'

class Weechat < Formula
  homepage 'http://www.weechat.org'
  url 'http://www.weechat.net/files/src/weechat-0.4.1.tar.bz2'
  sha1 'a5185d6b8a2b330713ea354f06601a205270e3a2'

  depends_on 'cmake' => :build
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

  # cmake finds brewed python when installed, but when searching for the 
  # libraries it searches for system libraries first. This patch disables 
  # default search paths and ensures that brewed python is found first, if not
  # it falls back to system python.
  def patches
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
    args << '-DENABLE_GUILE=OFF'  unless build.include? 'guile'

    # NLS/gettext support disabled for now since it doesn't work in stdenv
    # see https://github.com/mxcl/homebrew/issues/18722
    args << "-DENABLE_NLS=OFF"
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
--- weechat-0.4.1-original/cmake/FindPython.cmake 2013-05-20 03:06:14.000000000 -0500
+++ weechat-0.4.1/cmake/FindPython.cmake  2013-05-23 14:24:33.000000000 -0500
@@ -41,7 +41,8 @@
 ELSE(ENABLE_PYTHON3)
   FIND_PROGRAM(PYTHON_EXECUTABLE
     NAMES python2.7 python2.6 python2.5 python
-    PATHS /usr/bin /usr/local/bin /usr/pkg/bin
+    PATHS HOMEBREW_PREFIX/bin /usr/bin
+    NO_DEFAULT_PATH
     )
 ENDIF(ENABLE_PYTHON3)
 
@@ -74,6 +75,7 @@
     FIND_LIBRARY(PYTHON_LIBRARY
       NAMES python2.7 python2.6 python2.5 python
       PATHS ${PYTHON_POSSIBLE_LIB_PATH}
+      NO_DEFAULT_PATH
       )
   ENDIF(ENABLE_PYTHON3)
 

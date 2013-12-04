require 'formula'

class Weechat < Formula
  homepage 'http://www.weechat.org'
  url 'http://www.weechat.net/files/src/weechat-0.4.2.tar.bz2'
  sha1 '837892c8eb24b3d7de26e17e87aafe88d7da0862'

  head 'git://git.savannah.nongnu.org/weechat.git'

  depends_on 'cmake' => :build
  depends_on 'gnutls'
  depends_on 'libgcrypt'
  depends_on 'guile' => :optional
  depends_on 'aspell' => :optional
  depends_on 'lua' => :optional
  depends_on :python => :optional

  option 'with-perl', 'Build the perl module'
  option 'with-ruby', 'Build the ruby module'

  # cmake finds brewed python when installed, but when searching for the
  # libraries it searches for system libraries first. This patch disables
  # default search paths and ensures that brewed python is found first, if not
  # it falls back to system python.
  def patches
    DATA
  end

  def install
    args = std_cmake_args + %W[
      -DPREFIX=#{prefix}
      -DENABLE_GTK=OFF
    ]
    args << '-DENABLE_LUA=OFF'    unless build.with? 'lua'
    args << '-DENABLE_PERL=OFF'   unless build.with? 'perl'
    args << '-DENABLE_RUBY=OFF'   unless build.with? 'ruby'
    args << '-DENABLE_ASPELL=OFF' unless build.with? 'aspell'
    args << '-DENABLE_GUILE=OFF'  unless build.with? 'guile'

    # NLS/gettext support disabled for now since it doesn't work in stdenv
    # see https://github.com/mxcl/homebrew/issues/18722
    args << "-DENABLE_NLS=OFF"
    args << '..'

    mkdir 'build' do
      if python do
        system 'cmake', *args
      end
      else
        # The same cmake call but without any python set up.
        args << '-DENABLE_PYTHON=OFF'
        system 'cmake', *args
      end
      system 'make install'
    end
  end

  def caveats; <<-EOS.undent
      Weechat can depend on Aspell if you choose the --with-aspell option, but
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
 

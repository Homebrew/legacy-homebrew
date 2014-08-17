require 'formula'

class Gammu < Formula
  homepage 'http://wammu.eu/gammu/'
  url 'https://downloads.sourceforge.net/project/gammu/gammu/1.33.0/gammu-1.33.0.tar.bz2'
  sha1 'b7ee28e7398ea578290588d94d69c295491ff86a'

  depends_on 'cmake' => :build
  depends_on 'glib' => :recommended
  depends_on 'gettext' => :optional

  # Fixes issue https://github.com/gammu/gammu/issues/13
  patch :DATA

  def install
    args = std_cmake_args
    args << '-DINSTALL_BASH_COMPLETION=OFF'
    args << "-DWITH_PYTHON=OFF"

    system 'cmake', *args
    system 'make'
    system 'make install'
  end

end

__END__
diff --git a/python/setup.py b/python/setup.py
index feb66e8..0982927 100755
--- a/python/setup.py
+++ b/python/setup.py
@@ -282,6 +282,7 @@ gammumodule = Extension('gammu._gammu',
         'gammu/src/convertors/file.c',
         'gammu/src/convertors/call.c',
         'gammu/src/convertors/wap.c',
+        'gammu/src/convertors/diverts.c',
         'gammu/src/gammu.c',
         'gammu/src/smsd.c',
         ])

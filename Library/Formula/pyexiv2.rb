require 'formula'

class Pyexiv2 < Formula
  homepage 'http://tilloy.net/dev/pyexiv2/'
  url 'http://launchpad.net/pyexiv2/0.3.x/0.3.2/+download/pyexiv2-0.3.2.tar.bz2'
  sha1 'ad20ea6925571d58637830569076aba327ff56d9'

  depends_on 'scons' => :build
  depends_on 'exiv2'
  depends_on 'boost' => 'with-python'

  # Patch to use Framework Python
  patch :DATA

  def install
    # this build script ignores CPPFLAGS, but it honors CXXFLAGS
    ENV.append "CXXFLAGS", ENV.cppflags
    scons "BOOSTLIB=boost_python-mt"

    # let's install manually
    mv 'build/libexiv2python.dylib', 'build/libexiv2python.so'
    (lib+'python2.7/site-packages').install 'build/libexiv2python.so', 'src/pyexiv2'
  end
end

__END__
diff --git a/src/SConscript b/src/SConscript
index f4b3e8c..748cad0 100644
--- a/src/SConscript
+++ b/src/SConscript
@@ -26,6 +26,10 @@ env.Append(CPPPATH=[get_python_inc(plat_specific=True)])
 libs = [ARGUMENTS.get('BOOSTLIB', 'boost_python'), 'exiv2']
 env.Append(LIBS=libs)

+# Link against Python framework on OS X
+if env['PLATFORM'] == 'darwin':
+	env['FRAMEWORKS'] += ['Python']
+
 # Build shared library libpyexiv2
 cpp_sources = ['exiv2wrapper.cpp', 'exiv2wrapper_python.cpp']
 libpyexiv2 = env.SharedLibrary('exiv2python', cpp_sources)

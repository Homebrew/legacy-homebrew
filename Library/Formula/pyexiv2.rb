class Pyexiv2 < Formula
  desc "Python binding to exiv2 for manipulation of image metadata"
  homepage "http://tilloy.net/dev/pyexiv2/"
  url "https://launchpad.net/pyexiv2/0.3.x/0.3.2/+download/pyexiv2-0.3.2.tar.bz2"
  sha256 "0abc117c6afa71f54266cb91979a5227f60361db1fcfdb68ae9615398d7a2127"
  revision 1

  depends_on "scons" => :build
  depends_on "exiv2"
  depends_on "boost"
  depends_on "boost-python"

  # Patch to use Framework Python
  patch :DATA

  def install
    # this build script ignores CPPFLAGS, but it honors CXXFLAGS
    ENV.append "CXXFLAGS", ENV.cppflags
    ENV.append "CXXFLAGS", "-I#{Formula["boost"].include}"
    ENV.append "CXXFLAGS", "-I#{Formula["exiv2"].include}"

    scons "BOOSTLIB=boost_python-mt"

    # let's install manually
    mv "build/libexiv2python.dylib", "build/libexiv2python.so"
    (lib+"python2.7/site-packages").install "build/libexiv2python.so", "src/pyexiv2"
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

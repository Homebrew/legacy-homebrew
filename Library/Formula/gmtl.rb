require 'formula'

class Gmtl < Formula
  homepage 'http://ggt.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/ggt/Generic%20Math%20Template%20Library/0.6.1/gmtl-0.6.1.tar.gz'
  sha1 '473a454d17956d3ce3babafdb57f73c0685579fd'

  head 'https://ggt.svn.sourceforge.net/svnroot/ggt/trunk/'

  depends_on 'scons' => :build

  # Build assumes that Python is a framework, which isn't always true. See:
  # https://sourceforge.net/tracker/?func=detail&aid=3172856&group_id=43735&atid=437247
  # The SConstruct from gmtl's HEAD doesn't need to be patched
  def patches
    DATA unless build.head?
  end

  def install
    system "scons", "install", "prefix=#{prefix}"
  end
end

__END__
diff --git a/SConstruct b/SConstruct
index 8326a89..2eb7ff0 100644
--- a/SConstruct
+++ b/SConstruct
@@ -126,7 +126,9 @@ def BuildDarwinEnvironment():
 
    exp = re.compile('^(.*)\/Python\.framework.*$')
    m = exp.search(distutils.sysconfig.get_config_var('prefix'))
-   framework_opt = '-F' + m.group(1)
+   framework_opt = None
+   if m:
+      framework_opt = '-F' + m.group(1)
 
    CXX = os.environ.get("CXX", WhereIs('g++'))
 
@@ -138,7 +140,10 @@ def BuildDarwinEnvironment():
 
    LINK = CXX
    CXXFLAGS = ['-ftemplate-depth-256', '-DBOOST_PYTHON_DYNAMIC_LIB',
-               '-Wall', framework_opt, '-pipe']
+               '-Wall', '-pipe']
+
+   if framework_opt is not None:
+      CXXFLAGS.append(framework_opt)
 
    compiler_ver       = match_obj.group(1)
    compiler_major_ver = int(match_obj.group(2))
@@ -152,7 +157,10 @@ def BuildDarwinEnvironment():
          CXXFLAGS += ['-Wno-long-double', '-no-cpp-precomp']
 
    SHLIBSUFFIX = distutils.sysconfig.get_config_var('SO')
-   SHLINKFLAGS = ['-bundle', framework_opt, '-framework', 'Python']
+   SHLINKFLAGS = ['-bundle']
+
+   if framework_opt is not None:
+      SHLINKFLAGS.extend([framework_opt, '-framework', 'Python'])
    LINKFLAGS = []
 
    # Enable profiling?

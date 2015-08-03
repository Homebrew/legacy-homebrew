class Gmtl < Formula
  desc "Lightweight math library"
  homepage "http://ggt.sourceforge.net/"

  stable do
    url "https://downloads.sourceforge.net/project/ggt/Generic%20Math%20Template%20Library/0.6.1/gmtl-0.6.1.tar.gz"
    sha256 "f7d8e6958d96a326cb732a9d3692a3ff3fd7df240eb1d0921a7c5c77e37fc434"

    # Build assumes that Python is a framework, which isn't always true. See:
    # https://sourceforge.net/tracker/?func=detail&aid=3172856&group_id=43735&atid=437247
    # The SConstruct from gmtl's HEAD doesn't need to be patched
    patch :DATA
  end

  bottle do
    cellar :any
    sha1 "905af4149c167870069b22d3cb082897f8bf1259" => :mavericks
    sha1 "09ef2b92b09f46a1ee33866fda35494bbe545819" => :mountain_lion
    sha1 "3444ed4b6eb1859a64f3f7250656ae5c1e074fd3" => :lion
  end

  head "https://ggt.svn.sourceforge.net/svnroot/ggt/trunk/"

  depends_on "scons" => :build

  # The scons script in gmtl only works for gcc, patch it
  # https://sourceforge.net/p/ggt/bugs/28/
  patch do
    url "https://gist.githubusercontent.com/anonymous/c16cad998a4903e6b3a8/raw/e4669b3df0e14996c7b7b53937dd6b6c2cbc7c04/gmtl_Sconstruct.diff"
    sha256 "1167f89f52f88764080d5760b6d054036734b26c7fef474692ff82e9ead7eb3c"
  end

  def install
    scons "install", "prefix=#{prefix}"
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

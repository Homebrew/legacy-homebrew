require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Basemap < Formula
  homepage 'http://matplotlib.github.com/basemap/'
  url 'http://downloads.sourceforge.net/project/matplotlib/matplotlib-toolkits/basemap-1.0.4/basemap-1.0.4.tar.gz'
  sha1 'b6d312129d2ae7fb612490516cf87daaf18cb033'

  depends_on 'matplotlib'
  depends_on 'geos' => :build
  depends_on 'proj' => :build

  # Delete file 'lib/mpl_toolkits/__init__.py' which is already installed by the
  # matplotlib package.
  def patches
    DATA
  end

  def install
    ENV.x11
    system "python setup.py config"
    system "python setup.py build"
    system "python setup.py install --prefix=#{prefix}"
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end

  def site_package_dir
    "lib/#{which_python}/site-packages"
  end

  def caveats
    <<-EOS
basemap Python modules have been linked to:
    #{HOMEBREW_PREFIX}/#{site_package_dir}

Make sure this folder is on your PYTHONPATH.
    EOS
  end
end

__END__
diff --git a/MANIFEST.in b/MANIFEST.in
index b07af51..5ab19f3 100644
--- a/MANIFEST.in
+++ b/MANIFEST.in
@@ -85,7 +85,6 @@ include examples/rita.nc
 include examples/maskoceans.py
 include examples/utmtest.py
 include examples/README
-include lib/mpl_toolkits/__init__.py
 include lib/mpl_toolkits/basemap/__init__.py
 include lib/mpl_toolkits/basemap/proj.py
 include lib/mpl_toolkits/basemap/pyproj.py
diff --git a/lib/mpl_toolkits/__init__.py b/lib/mpl_toolkits/__init__.py
deleted file mode 100644
index 8d9942e..0000000
--- a/lib/mpl_toolkits/__init__.py
+++ /dev/null
@@ -1,4 +0,0 @@
-try:
-    __import__('pkg_resources').declare_namespace(__name__)
-except ImportError:
-    pass # must not have setuptools


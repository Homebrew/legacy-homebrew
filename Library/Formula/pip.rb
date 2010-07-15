require 'formula'

class Pip <Formula
  url 'http://pypi.python.org/packages/source/p/pip/pip-0.7.2.tar.gz'
  homepage 'http://pip.openplans.org/'
  md5 'cfe73090aaa0d3b0c104179a627859d1'

  depends_on 'distribute'

  def patches
    # Create a locations branch for darwin with placeholders
    DATA
  end

  def install
    python = Formula.factory("python")
    unless python.installed?
      onoe "The \"pip\" brew is only meant to be used against a Homebrew-built Python."
      puts <<-EOS
        Homebrew's "pip" formula is only meant to be installed against a Homebrew-
        built version of Python, but we couldn't find such a version.

        The system-provided Python comes with "easy_install" already installed, with the
        caveat that some Python packages don't install cleanly against Apple's customized
        versions of Python.

        To install pip against a custom Python:
        First download distribute from:
          http://pypi.python.org/pypi/distribute
        unzip, and run:
          /path/to/custom/python setup.py install

        Then download pip from:
          http://pypi.python.org/pypi/pip
        unzip, and run:
          /path/to/custom/python setup.py install
      EOS
      exit 99
    end

    inreplace 'pip/locations.py' do |s|
      # Replace placeholders with HOMEBREW paths
      s.gsub! '#BUILD_PREFIX#', "'#{var}/pip/build'"
      s.gsub! '#SRC_PREFIX#', "'#{var}/pip/src'"
      s.gsub! '#STORAGE_DIR#', "'#{var}/pip'"
      s.gsub! '#CONFIG_FILE#', "'#{etc}/pip.conf'"
      s.gsub! '#LOG_FILE#', "'#{var}/pip/pip.log'"
    end

    system "#{python.bin}/python", "setup.py", "install",
              "--install-scripts", bin,
              "--install-purelib", python.site_packages,
              "--install-platlib", python.site_packages

    (prefix+"README.homebrew").write <<-EOF
pip's libraries were installed directly into:
  #{python.site_packages}
EOF
  end

  def caveats
    <<-EOS.undent
      This formula is only meant to be used against a Homebrew-built Python.
      It will install itself directly into Python's location in the Cellar.

      Pip's configuration file lives at:
        #{etc}/pip.conf
    EOS
  end
end


__END__
diff --git a/pip/locations.py b/pip/locations.py
index 292020c..2372314 100644
--- a/pip/locations.py
+++ b/pip/locations.py
@@ -10,8 +10,8 @@ if getattr(sys, 'real_prefix', None):
     src_prefix = os.path.join(sys.prefix, 'src')
 else:
     ## FIXME: this isn't a very good default
-    build_prefix = os.path.join(os.getcwd(), 'build')
-    src_prefix = os.path.join(os.getcwd(), 'src')
+    build_prefix = #BUILD_PREFIX#
+    src_prefix = #SRC_PREFIX#
 
 # FIXME doesn't account for venv linked to global site-packages
 
@@ -26,11 +26,16 @@ if sys.platform == 'win32':
     default_storage_dir = os.path.join(user_dir, 'pip')
     default_config_file = os.path.join(default_storage_dir, 'pip.ini')
     default_log_file = os.path.join(default_storage_dir, 'pip.log')
+elif sys.platform[:6] == 'darwin':
+    bin_py = os.path.join(sys.prefix, 'bin')
+    default_storage_dir = #STORAGE_DIR#
+    default_config_file = #CONFIG_FILE#
+    default_log_file = #LOG_FILE#
+    # Forcing to use /usr/local/bin for standard Mac OS X framework installs
+    if sys.prefix[:16] == '/System/Library/':
+        bin_py = '/usr/local/bin'
 else:
     bin_py = os.path.join(sys.prefix, 'bin')
     default_storage_dir = os.path.join(user_dir, '.pip')
     default_config_file = os.path.join(default_storage_dir, 'pip.conf')
     default_log_file = os.path.join(default_storage_dir, 'pip.log')
-    # Forcing to use /usr/local/bin for standard Mac OS X framework installs
-    if sys.platform[:6] == 'darwin' and sys.prefix[:16] == '/System/Library/':
-        bin_py = '/usr/local/bin'

require 'formula'

class Pyqwt < Formula
  homepage 'http://pyqwt.sourceforge.net'
  url 'http://sourceforge.net/projects/pyqwt/files/pyqwt5/PyQwt-5.2.0/PyQwt-5.2.0.tar.gz'
  sha1 '797f37c63dec660272f6a8ccfd16a017df0ad640'

  depends_on 'qt'
  depends_on 'qwt'
  depends_on 'sip'
  depends_on 'pyqt'

  def patches
    # Patch to build system to allow for specific
    #  installation directories.
    {:p0 => DATA}
  end

  def install
    cd "configure" do
      system "python",
             "configure.py",
             "--module-install-path=#{lib}/#{which_python}/site-packages/PyQt4/Qwt5",
             "--sip-install-path=#{share}/sip/Qwt5",
             "--uic-install-path=#{lib}/#{which_python}/site-packages/PyQt4",
             "-Q", "../qwt-5.2"
      system "make install"
    end
  end

  def caveats; <<-EOS.undent
    For non-homebrew Python, you need to amend your PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH
    EOS
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end

  def test
    system "python", "-c", "from PyQt4 import Qwt5 as Qwt"
  end
end

__END__
--- configure/configure.py	2011-10-24 19:14:41.000000000 -0500
+++ configure/configure.py	2011-10-24 19:15:03.000000000 -0500
@@ -846,14 +846,14 @@
     pattern = os.path.join(os.pardir, 'sip', options.qwt, 'common', '*.sip')
     sip_files += [os.path.join(os.pardir, f) for f in glob.glob(pattern)]
     installs.append(
-        [sip_files, os.path.join(configuration.pyqt_sip_dir, 'Qwt5')])
+        [sip_files, os.path.join(options.sip_install_path, 'Qwt5')])
 
     # designer
     if configuration.qt_version > 0x03ffff:
         plugin_source_path = os.path.join(
             os.pardir, 'qt4lib', 'PyQt4', 'uic', 'widget-plugins') 
         plugin_install_path = os.path.join(
-            configuration.pyqt_mod_dir, 'uic', 'widget-plugins')
+            options.uic_install_path, 'uic', 'widget-plugins')
         compileall.compile_dir(plugin_source_path, ddir=plugin_install_path)
         pattern = os.path.join(plugin_source_path, '*.py*')
         plugin_files = [os.path.join(os.pardir, f) for f in glob.glob(pattern)]
@@ -1025,6 +1025,14 @@
         '--module-install-path', default='', action='store',
         help= 'specify the install directory for the Python modules'
         )
+    install_options.add_option(
+        '--sip-install-path', default='', action='store',
+        help= 'specify the install directory for the sip files [share/sip]'
+        )
+    install_options.add_option(
+        '--uic-install-path', default='', action='store',
+        help= 'specify the install directory for the uic plugins [lib/python/PyQt4]'
+        )
     parser.add_option_group(install_options)
 
     options, args =  parser.parse_args()
@@ -1084,6 +1092,10 @@
     if not options.module_install_path:
         options.module_install_path = os.path.join(
             configuration.pyqt_mod_dir, 'Qwt5')
+    if not options.sip_install_path:
+        options.sip_install_path = configuration.pyqt_sip_dir
+    if not options.uic_install_path:
+        options.uic_install_path = configuration.pyqt_mod_dir
 
     print
     print 'Extended command line options:'

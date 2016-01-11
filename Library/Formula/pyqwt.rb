class Pyqwt < Formula
  desc "Python bindings for Qwt, widgets for science and engineering"
  homepage "http://pyqwt.sourceforge.net"
  url "https://downloads.sourceforge.net/project/pyqwt/pyqwt5/PyQwt-5.2.0/PyQwt-5.2.0.tar.gz"
  sha256 "98a8c7e0c76d07701c11dffb77793b05f071b664a8b520d6e97054a98179e70b"

  bottle do
    cellar :any
    sha256 "3ad94e2532ca76b2e88e1af10b08df8d6775bfd56d401be0590b1e6a39e3651b" => :yosemite
    sha256 "774dcf04f86a8b64672a9d6ec9580956f951a35d29d6f05ec2f5e4a5ee584b44" => :mavericks
    sha256 "736d1306c9929a54f7e4b9c27785bf0a8069bdb63e2fb03675cf00f4adb7475f" => :mountain_lion
  end

  depends_on :python
  depends_on "qt"
  depends_on "qwt"
  depends_on "sip"
  depends_on "pyqt"

  # Patch to build system to allow for specific installation directories.
  patch :p0, :DATA

  def install
    cd "configure" do
      system "python",
             "configure.py",
             "--module-install-path=#{lib}/python2.7/site-packages/PyQt4/Qwt5",
             "--sip-install-path=#{share}/sip/Qwt5",
             "--uic-install-path=#{lib}/python2.7/site-packages/PyQt4",
             "-Q", "../qwt-5.2"
      system "make", "install"
      system "make", "clean"
    end
  end

  test do
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
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

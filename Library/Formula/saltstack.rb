require 'formula'

class Saltstack < Formula
  homepage 'http://saltstack.org/'
  url 'http://pypi.python.org/packages/source/s/salt/salt-0.13.1.tar.gz'
  sha1 '22d488922f1c9ddc98765737d9e066dc63997959'

  option 'with-deps', "Install Python dependencies automatically"

  depends_on 'swig' => :build
  depends_on :python
  depends_on 'zeromq'

  if not build.include? 'with-deps'
    depends_on 'jinja2' => :python
    depends_on 'M2Crypto' => :python
    depends_on LanguageModuleDependency.new :python, 'PyCrypto', 'Crypto'
    depends_on LanguageModuleDependency.new :python, 'pyzmq', 'zmq'
    depends_on LanguageModuleDependency.new :python, 'PyYAML', 'yaml'
    depends_on LanguageModuleDependency.new :python, 'msgpack-python', 'msgpack'
  end

  # Place salt config dir under Homebrew's etc dir
  def patches; DATA; end

  def install
    if build.include? 'with-deps'
      system "pip", "install", "-r", "requirements.txt"
    end

    args = [
      "--no-user-cfg",
      "--verbose",
      "install",
      "--force",
      "--install-scripts=#{bin}",
      "--install-lib=#{lib}",
      "--install-data=#{share}",
      "--install-headers=#{include}",
    ]

    system python, "-s", "setup.py", *args
  end

  def test
    system "${bin}/salt --version"
  end
end


__END__
diff --git a/salt/client.py b/salt/client.py
index 81b7550..394d8a7 100644
--- a/salt/client.py
+++ b/salt/client.py
@@ -69,7 +69,7 @@ class LocalClient(object):
     '''
     Connect to the salt master via the local server and via root
     '''
-    def __init__(self, c_path='/etc/salt/master', mopts=None):
+    def __init__(self, c_path='HOMEBREW_PREFIX/etc/salt/master', mopts=None):
         if mopts:
             self.opts = mopts
         else:
@@ -1061,7 +1061,7 @@ class Caller(object):
     '''
     Create an object used to call salt functions directly on a minion
     '''
-    def __init__(self, c_path='/etc/salt/minion'):
+    def __init__(self, c_path='HOMEBREW_PREFIX/etc/salt/minion'):
         self.opts = salt.config.minion_config(c_path)
         self.sminion = salt.minion.SMinion(self.opts)
 
diff --git a/salt/config.py b/salt/config.py
index fb344de..6b149a7 100644
--- a/salt/config.py
+++ b/salt/config.py
@@ -39,13 +39,13 @@ DEFAULT_MINION_OPTS = {
     'master_port': '4506',
     'master_finger': '',
     'user': 'root',
-    'root_dir': '/',
-    'pki_dir': '/etc/salt/pki/minion',
+    'root_dir': 'HOMEBREW_PREFIX',
+    'pki_dir': 'HOMEBREW_PREFIX/etc/salt/pki/minion',
     'id': socket.getfqdn(),
-    'cachedir': '/var/cache/salt/minion',
+    'cachedir': 'HOMEBREW_PREFIX/var/cache/salt/minion',
     'cache_jobs': False,
-    'conf_file': '/etc/salt/minion',
-    'sock_dir': '/var/run/salt/minion',
+    'conf_file': 'HOMEBREW_PREFIX/etc/salt/minion',
+    'sock_dir': 'HOMEBREW_PREFIX/var/run/salt/minion',
     'backup_mode': '',
     'renderer': 'yaml_jinja',
     'failhard': False,
@@ -79,7 +79,7 @@ DEFAULT_MINION_OPTS = {
     'ipc_mode': 'ipc',
     'tcp_pub_port': 4510,
     'tcp_pull_port': 4511,
-    'log_file': '/var/log/salt/minion',
+    'log_file': 'HOMEBREW_PREFIX/var/log/salt/minion',
     'log_level': None,
     'log_level_logfile': None,
     'log_datefmt': _DFLT_LOG_DATEFMT,
@@ -116,13 +116,13 @@ DEFAULT_MASTER_OPTS = {
     'auth_mode': 1,
     'user': 'root',
     'worker_threads': 5,
-    'sock_dir': '/var/run/salt/master',
+    'sock_dir': 'HOMEBREW_PREFIX/var/run/salt/master',
     'ret_port': '4506',
     'timeout': 5,
     'keep_jobs': 24,
     'root_dir': '/',
-    'pki_dir': '/etc/salt/pki/master',
-    'cachedir': '/var/cache/salt/master',
+    'pki_dir': 'HOMEBREW_PREFIX/etc/salt/pki/master',
+    'cachedir': 'HOMEBREW_PREFIX/var/cache/salt/master',
     'file_roots': {
         'base': ['/srv/salt'],
         },
@@ -149,7 +149,7 @@ DEFAULT_MASTER_OPTS = {
     'fileserver_backend': ['roots'],
     'max_open_files': 100000,
     'hash_type': 'md5',
-    'conf_file': '/etc/salt/master',
+    'conf_file': 'HOMEBREW_PREFIX/etc/salt/master',
     'open_mode': False,
     'auto_accept': False,
     'renderer': 'yaml_jinja',
@@ -162,7 +162,7 @@ DEFAULT_MASTER_OPTS = {
     'ext_job_cache': '',
     'master_ext_job_cache': '',
     'minion_data_cache': True,
-    'log_file': '/var/log/salt/master',
+    'log_file': 'HOMEBREW_PREFIX/var/log/salt/master',
     'log_level': None,
     'log_level_logfile': None,
     'log_datefmt': _DFLT_LOG_DATEFMT,
@@ -170,7 +170,7 @@ DEFAULT_MASTER_OPTS = {
     'log_fmt_console': _DFLT_LOG_FMT_CONSOLE,
     'log_fmt_logfile': _DFLT_LOG_FMT_LOGFILE,
     'log_granular_levels': {},
-    'pidfile': '/var/run/salt-master.pid',
+    'pidfile': 'HOMEBREW_PREFIX/var/run/salt-master.pid',
     'cluster_masters': [],
     'cluster_mode': 'paranoid',
     'range_server': 'range:80',
@@ -183,7 +183,7 @@ DEFAULT_MASTER_OPTS = {
     'loop_interval': 60,
     'nodegroups': {},
     'cython_enable': False,
-    'key_logfile': '/var/log/salt/key',
+    'key_logfile': 'HOMEBREW_PREFIX/var/log/salt/key',
     'verify_env': True,
     'permissive_pki_access': False,
     'default_include': 'master.d/*.conf',
diff --git a/salt/utils/parsers.py b/salt/utils/parsers.py
index 7f6b42e..44f6340 100644
--- a/salt/utils/parsers.py
+++ b/salt/utils/parsers.py
@@ -229,7 +229,7 @@ class ConfigDirMixIn(object):
 
     def _mixin_setup(self):
         self.add_option(
-            '-c', '--config-dir', default='/etc/salt',
+            '-c', '--config-dir', default='HOMEBREW_PREFIX/etc/salt',
             help=('Pass in an alternative configuration directory. Default: '
                   '%default')
         )
@@ -946,7 +946,7 @@ class SaltKeyOptionParser(OptionParser, ConfigDirMixIn, MergeConfigMixIn,
 
         self.add_option(
             '--key-logfile',
-            default='/var/log/salt/key',
+            default='HOMEBREW_PREFIX/var/log/salt/key',
             help=('Send all output to a file. Default is %default')
         )

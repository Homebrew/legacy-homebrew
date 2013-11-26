require 'formula'

class NpmNotInstalled < Requirement
  fatal true

  def modules_folder
    "#{HOMEBREW_PREFIX}/lib/node_modules"
  end

  def message; <<-EOS.undent
    Beginning with 0.8.0, this recipe now comes with npm.
    It appears you already have npm installed at #{modules_folder}/npm.
    To use the npm that comes with this recipe, first uninstall npm with
    `npm uninstall npm -g`, then run this command again.

    If you would like to keep your installation of npm instead of
    using the one provided with homebrew, install the formula with
    the `--without-npm` option.
    EOS
  end

  satisfy :build_env => false do
    begin
      path = Pathname.new("#{modules_folder}/npm/bin/npm")
      path.realpath.to_s.include?(HOMEBREW_CELLAR)
    rescue Errno::ENOENT
      true
    end
  end
end

# Note that x.even are stable releases, x.odd are devel releases
class Node < Formula
  homepage 'http://nodejs.org/'
  url 'http://nodejs.org/dist/v0.10.22/node-v0.10.22.tar.gz'
  sha1 'd7c6a39dfa714eae1f8da7a00c9a07efd74a03b3'

  devel do
    url 'http://nodejs.org/dist/v0.11.9/node-v0.11.9.tar.gz'
    sha1 'b4fc0e38ccde4edae45db198f331499055d77ca2'
  end

  head 'https://github.com/joyent/node.git'

  option 'enable-debug', 'Build with debugger hooks'
  option 'without-npm', 'npm will not be installed'

  depends_on NpmNotInstalled unless build.without? 'npm'
  depends_on :python => ["2.6", :build]

  fails_with :llvm do
    build 2326
  end

  # fixes gyp's detection of system paths on CLT-only systems
  def patches; DATA; end

  def install
    args = %W{--prefix=#{prefix}}

    args << "--debug" if build.include? 'enable-debug'
    args << "--without-npm" if build.include? 'without-npm'

    system "./configure", *args
    system "make install"

    unless build.include? 'without-npm'
      (lib/"node_modules/npm/npmrc").write("prefix = #{npm_prefix}\n")

      # Link npm manpages
      Pathname.glob("#{lib}/node_modules/npm/man/*").each do |man|
        dir = send(man.basename)
        man.children.each do |file|
          dir.install_symlink(file.relative_path_from(dir))
        end
      end
    end
  end

  def npm_prefix
    d = "#{HOMEBREW_PREFIX}/share/npm"
    if File.directory? d
      d
    else
      HOMEBREW_PREFIX.to_s
    end
  end

  def caveats
    if build.include? 'without-npm' then <<-end.undent
      Homebrew has NOT installed npm. If you later install it, you should supplement
      your NODE_PATH with the npm module folder:
          #{npm_prefix}/lib/node_modules
      end
    elsif not ENV['PATH'].split(':').include? "#{npm_prefix}/bin"; <<-end.undent
      Probably you should amend your PATH to include npm-installed binaries:
          #{npm_prefix}/bin
      end
    end
  end
end

__END__
diff --git a/tools/gyp/pylib/gyp/xcode_emulation.py b/tools/gyp/pylib/gyp/xcode_emulation.py
index f9cec33..4b3c035 100644
--- a/tools/gyp/pylib/gyp/xcode_emulation.py
+++ b/tools/gyp/pylib/gyp/xcode_emulation.py
@@ -285,8 +285,14 @@ class XcodeSettings(object):
     if sdk_root.startswith('/'):
       return sdk_root
     if sdk_root not in XcodeSettings._sdk_path_cache:
-      XcodeSettings._sdk_path_cache[sdk_root] = self._GetSdkVersionInfoItem(
-          sdk_root, 'Path')
+      try:
+        XcodeSettings._sdk_path_cache[sdk_root] = self._GetSdkVersionInfoItem(
+            sdk_root, 'Path')
+      except:
+        # if this fails it's because xcodebuild failed, which means
+        # the user is probably on a CLT-only system, where there
+        # is no valid SDK root
+        XcodeSettings._sdk_path_cache[sdk_root] = None
     return XcodeSettings._sdk_path_cache[sdk_root]

   def _AppendPlatformVersionMinFlags(self, lst):
@@ -397,10 +403,11 @@ class XcodeSettings(object):

     cflags += self._Settings().get('WARNING_CFLAGS', [])

-    config = self.spec['configurations'][self.configname]
-    framework_dirs = config.get('mac_framework_dirs', [])
-    for directory in framework_dirs:
-      cflags.append('-F' + directory.replace('$(SDKROOT)', sdk_root))
+    if 'SDKROOT' in self._Settings():
+      config = self.spec['configurations'][self.configname]
+      framework_dirs = config.get('mac_framework_dirs', [])
+      for directory in framework_dirs:
+        cflags.append('-F' + directory.replace('$(SDKROOT)', sdk_root))

     self.configname = None
     return cflags
@@ -647,10 +654,11 @@ class XcodeSettings(object):
     for rpath in self._Settings().get('LD_RUNPATH_SEARCH_PATHS', []):
       ldflags.append('-Wl,-rpath,' + rpath)

-    config = self.spec['configurations'][self.configname]
-    framework_dirs = config.get('mac_framework_dirs', [])
-    for directory in framework_dirs:
-      ldflags.append('-F' + directory.replace('$(SDKROOT)', self._SdkPath()))
+    if 'SDKROOT' in self._Settings():
+      config = self.spec['configurations'][self.configname]
+      framework_dirs = config.get('mac_framework_dirs', [])
+      for directory in framework_dirs:
+        ldflags.append('-F' + directory.replace('$(SDKROOT)', self._SdkPath()))

     self.configname = None
     return ldflags
@@ -826,7 +834,10 @@ class XcodeSettings(object):
         l = '-l' + m.group(1)
       else:
         l = library
-    return l.replace('$(SDKROOT)', self._SdkPath(config_name))
+    if self._SdkPath():
+      return l.replace('$(SDKROOT)', self._SdkPath(config_name))
+    else:
+      return l

   def AdjustLibraries(self, libraries, config_name=None):
     """Transforms entries like 'Cocoa.framework' in libraries into entries like

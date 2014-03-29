require 'formula'

class Fceux < Formula
  homepage 'http://fceux.com'
  url 'https://downloads.sourceforge.net/project/fceultra/Source%20Code/2.2.2%20src/fceux-2.2.2.src.tar.gz'
  sha1 'ec50d8eae04794ba10f441a26cdb410c1cf6832b'

  option 'no-gtk', "Build without Gtk+ support"

  depends_on 'pkg-config' => :build
  depends_on 'scons' => :build
  depends_on 'sdl'
  depends_on 'libzip'
  depends_on 'gtk+' unless build.include? "no-gtk"
  depends_on 'lua'
  depends_on :x11

  # Make scons honor PKG_CONFIG_PATH and PKG_CONFIG_LIBDIR
  # Reported upstream: https://sourceforge.net/p/fceultra/bugs/625
  patch :DATA

  def install
    args = []
    args << "GTK=0" if build.include? "no-gtk"
    scons *args
    bin.install 'src/fceux'
  end
end

__END__
diff --git a/SConstruct b/SConstruct
index 4d5b446..36be2c4 100644
--- a/SConstruct
+++ b/SConstruct
@@ -62,6 +62,10 @@ if os.environ.has_key('CPPFLAGS'):
   env.Append(CPPFLAGS = os.environ['CPPFLAGS'].split())
 if os.environ.has_key('LDFLAGS'):
   env.Append(LINKFLAGS = os.environ['LDFLAGS'].split())
+if os.environ.has_key('PKG_CONFIG_PATH'):
+  env['ENV']['PKG_CONFIG_PATH'] = os.environ['PKG_CONFIG_PATH']
+if os.environ.has_key('PKG_CONFIG_LIBDIR'):
+  env['ENV']['PKG_CONFIG_LIBDIR'] = os.environ['PKG_CONFIG_LIBDIR']
 
 print "platform: ", env['PLATFORM']
 
@@ -112,16 +116,12 @@ else:
       Exit(1)
     # Add compiler and linker flags from pkg-config
     config_string = 'pkg-config --cflags --libs gtk+-2.0'
-    if env['PLATFORM'] == 'darwin':
-      config_string = 'PKG_CONFIG_PATH=/opt/X11/lib/pkgconfig/ ' + config_string
     env.ParseConfig(config_string)
     env.Append(CPPDEFINES=["_GTK2"])
     env.Append(CCFLAGS = ["-D_GTK"])
   if env['GTK3']:
     # Add compiler and linker flags from pkg-config
     config_string = 'pkg-config --cflags --libs gtk+-3.0'
-    if env['PLATFORM'] == 'darwin':
-      config_string = 'PKG_CONFIG_PATH=/opt/X11/lib/pkgconfig/ ' + config_string
     env.ParseConfig(config_string)
     env.Append(CPPDEFINES=["_GTK3"])
     env.Append(CCFLAGS = ["-D_GTK"])
diff --git a/src/drivers/sdl/SConscript b/src/drivers/sdl/SConscript
index 7a53b07..23e11b9 100644
--- a/src/drivers/sdl/SConscript
+++ b/src/drivers/sdl/SConscript
@@ -2,8 +2,6 @@
 # Thanks Antonio Ospite!
 Import('env')
 config_string = 'pkg-config --cflags --libs x11'
-if env['PLATFORM'] == 'darwin':
-  config_string = 'PKG_CONFIG_PATH=/opt/X11/lib/pkgconfig/ ' + config_string
 env.ParseConfig(config_string)
 Export('env')
 

require "formula"

class Jsoncpp < Formula
  homepage "http://sourceforge.net/projects/jsoncpp/"
  url "https://downloads.sourceforge.net/project/jsoncpp/jsoncpp/0.6.0-rc2/jsoncpp-src-0.6.0-rc2.tar.gz"
  sha1 "a14eb501c44e610b8aaa2962bd1cc1775ed4fde2"

  depends_on "scons" => :build

  def patches
    # The git checkout on the homebrew test server strips <CR><LF>, therefore to get the patch
    # to apply cleanly, we must strip them from the file to be patched too.
    if @buildpath then
      inreplace 'SConstruct' do |s|
        s.gsub! /\r\n/, "\n"
      end
    end
    DATA
  end
  
  def install
    scons "platform=darwin-llvm"
    platformName = "darwin-llvm-" + `#{ENV.cc} -dumpversion`.chomp

    lib.install "libs/#{platformName}/libjson_#{platformName}_libmt.dylib"
    lib.install "libs/#{platformName}/libjson_#{platformName}_libmt.a"
    lib.install_symlink "libjson_#{platformName}_libmt.dylib" => "libjsoncpp.dylib"
    lib.install_symlink "libjson_#{platformName}_libmt.a" => "libjsoncpp.a"
    prefix.install "include"

    libexec.install "bin/#{platformName}/test_lib_json" => "test_lib_json"
  end

  test do
    system "#{libexec}/test_lib_json"
  end
end

__END__
--- jsoncpp-src-0.6.0-rc2/SConstruct	2014-04-18 11:58:57.000000000 +0100
+++ jsoncpp-src-0.6.0-rc2-darwin/SConstruct	2014-04-18 11:59:05.000000000 +0100
@@ -18,16 +18,16 @@
 options.Add( EnumVariable('platform',
                         'Platform (compiler/stl) used to build the project',
                         'msvc71',
-                        allowed_values='suncc vacpp mingw msvc6 msvc7 msvc71 msvc80 msvc90 linux-gcc'.split(),
+                        allowed_values='suncc vacpp mingw msvc6 msvc7 msvc71 msvc80 msvc90 linux-gcc darwin-llvm'.split(),
                         ignorecase=2) )
 
 try:
     platform = ARGUMENTS['platform']
-    if platform == 'linux-gcc':
+    if platform == 'linux-gcc' or platform == 'darwin-llvm':
         CXX = 'g++' # not quite right, but env is not yet available.
         import commands
         version = commands.getoutput('%s -dumpversion' %CXX)
-        platform = 'linux-gcc-%s' %version
+        platform = '%s-%s' %(platform, version)
         print "Using platform '%s'" %platform
         LD_LIBRARY_PATH = os.environ.get('LD_LIBRARY_PATH', '')
         LD_LIBRARY_PATH = "%s:libs/%s" %(LD_LIBRARY_PATH, platform)
@@ -117,7 +117,7 @@
 elif platform == 'mingw':
     env.Tool( 'mingw' )
     env.Append( CPPDEFINES=[ "WIN32", "NDEBUG", "_MT" ] )
-elif platform.startswith('linux-gcc'):
+elif platform.startswith('linux-gcc') or platform.startswith('darwin'):
     env.Tool( 'default' )
     env.Append( LIBS = ['pthread'], CCFLAGS = "-Wall" )
     env['SHARED_LIB_ENABLED'] = True

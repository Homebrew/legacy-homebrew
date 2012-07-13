require 'formula'

class Bento4 < Formula
  homepage 'http://zebulon.bok.net/trac/Bento4'
  version '1.3.3-431'
  url 'http://sourceforge.net/projects/bento4/files/Bento4%20Source/1.3.3-431/Bento4-SRC-1-3-3-431.zip'
  sha1 '9e5d462b2437e363616fc44228041c704f0cf726'
  head 'https://zebulon.bok.net/svn/Bento4/trunk', :using => :svn

  depends_on 'scons' => :build

  def patches
    # Updates the SCons rule to work with Xcode 4 CLT
    DATA
  end

  def install
    system "scons", "build_config=Release"

    # there's no install rule, roughly following the layout of the binary package
    cd 'Build/Targets/universal-apple-macosx/Release/' do
      %w{aac2mp4 mp42aac mp42ts mp4dcfpackager mp4decrypt mp4dump mp4edit mp4encrypt
         mp4extract mp4fragment mp4info mp4rtphintinfo mp4tag}.each do |tool|
        bin.install(tool)
      end
      mv 'libBento4C.so', 'libBento4C.dylib'
      lib.install('libBento4.a', 'libBento4C.dylib')
    end
  end

  def test
    # one of the few commands that don't return 1 due to missing file argument
    system "mp4tag", "--list-keys"
  end
end

__END__
diff --git a/Build/Targets/universal-apple-macosx/Config.scons b/Build/Targets/universal-apple-macosx/Config.scons
index 3a0a782..325487c 100644
--- a/Build/Targets/universal-apple-macosx/Config.scons
+++ b/Build/Targets/universal-apple-macosx/Config.scons
@@ -1,11 +1,5 @@
 ### Special for the MAC: universal flags
-universal_flags = '-arch ppc -arch i386 -isysroot /Developer/SDKs/MacOSX10.4u.sdk -mmacosx-version-min=10.4'
-
-### We need to use gcc 4.0 on Snow Leopard (10.6) for MacOSX10.4u.sdk
-import platform
-if platform.mac_ver()[0][:4] == '10.6':
-    env['CC']  = 'gcc-4.0'
-    env['CXX'] = 'g++-4.0'
+universal_flags = '-arch i386 -arch x86_64 -mmacosx-version-min=10.4'
 
 LoadTool('gcc-generic', env, gcc_extra_options=universal_flags)
 

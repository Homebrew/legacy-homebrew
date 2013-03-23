require 'formula'

class MplayerHeadDownloadStrategy < StrictSubversionDownloadStrategy
  def stage
    quiet_safe_system @@svn, 'export', '--force', @co, Dir.pwd
    snapshot_file = File.join(Dir.pwd,'snapshot_version')
    checkout = @co
    quiet_safe_system ("svnversion #{checkout} > #{snapshot_file}")
  end
end

class Mplayer < Formula
  homepage 'http://www.mplayerhq.hu/'
  url 'http://www.mplayerhq.hu/MPlayer/releases/MPlayer-1.1.tar.xz'
  sha1 '913a4bbeab7cbb515c2f43ad39bc83071b2efd75'

  head 'svn://svn.mplayerhq.hu/mplayer/trunk', :using => MplayerHeadDownloadStrategy

  option 'with-x', 'Build with X11 support'
  option 'without-osd', 'Build without OSD'

  depends_on 'yasm' => :build
  depends_on 'xz' => :build
  depends_on :x11 if build.include? 'with-x'

  unless build.include? 'without-osd' or build.include? 'with-x'
    # These are required for the OSD. We can get them from X11, or we can
    # build our own.
    depends_on :fontconfig
    depends_on :freetype
  end

  fails_with :clang do
    build 211
    cause 'Inline asm errors during compile on 32bit Snow Leopard.'
  end unless MacOS.prefer_64_bit?

  def patches
    # When building SVN, configure prompts the user to pull FFmpeg from git.
    # Don't do that.
    DATA if build.head?
  end

  def install
    # (A) Do not use pipes, per bug report and MacPorts
    # * https://github.com/mxcl/homebrew/issues/622
    # * http://trac.macports.org/browser/trunk/dports/multimedia/mplayer-devel/Portfile
    # (B) Any kind of optimisation breaks the build
    # (C) It turns out that ENV.O1 fixes link errors with llvm.
    ENV['CFLAGS'] = ''
    ENV['CXXFLAGS'] = ''
    ENV.O1 if ENV.compiler == :llvm

    # we disable cdparanoia because homebrew's version is hacked to work on OS X
    # and mplayer doesn't expect the hacks we apply. So it chokes.
    # Specify our compiler to stop ffmpeg from defaulting to gcc.
    # Disable openjpeg because it defines int main(), which hides mplayer's main().
    # This issue was reported upstream against openjpeg 1.5.0:
    # http://code.google.com/p/openjpeg/issues/detail?id=152
    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --disable-cdparanoia
      --disable-libopenjpeg
    ]

    args << "--enable-menu" unless build.include? 'without-osd'
    args << "--disable-x11" unless build.include? 'with-x'

    system "./configure", *args
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/mplayer", "-ao", "null", "/System/Library/Sounds/Glass.aiff"
  end
end

__END__
diff --git a/configure b/configure
index a1fba5f..5deaa80 100755
--- a/configure
+++ b/configure
@@ -49,8 +49,6 @@ if test -e ffmpeg/mp_auto_pull ; then
 fi
 
 if ! test -e ffmpeg ; then
-    echo "No FFmpeg checkout, press enter to download one with git or CTRL+C to abort"
-    read tmp
     if ! git clone --depth 1 git://source.ffmpeg.org/ffmpeg.git ffmpeg ; then
         rm -rf ffmpeg
         echo "Failed to get a FFmpeg checkout"
@@ -1729,7 +1729,6 @@
 _getch=getch2.c
 
 if darwin; then
-  extra_cflags="-mdynamic-no-pic $extra_cflags"
   _timer=timer-darwin.c
 fi
 
@@ -2771,8 +2770,8 @@
     extra_ldflags="$extra_ldflags -pie"
     relocatable=yes
     res_comment="non-PIC"
-  elif x86_64 && cflag_check -fpie -pie ; then
-    extra_ldflags="$extra_ldflags -fpie -pie"
+  elif x86_64 && cflag_check -fpie -Wl,-pie; then
+    extra_ldflags="$extra_ldflags -fpie -Wl,-pie"
     extra_cflags="$extra_cflags -fpie"
     relocatable=yes
     res_comment="fast PIC"
@@ -2847,8 +2846,7 @@
 echocheck "PIC"
 def_pic='#define CONFIG_PIC 0'
 pic=no
-cpp_condition_check '' 'defined(__PIC__) || defined(__pic__) || defined(PIC)' &&
-  pic=yes && extra_cflags="$extra_cflags -DPIC" && def_pic='#define CONFIG_PIC 1'
+pic=yes && extra_cflags="$extra_cflags -DPIC" && def_pic='#define CONFIG_PIC 1'
 echores $pic

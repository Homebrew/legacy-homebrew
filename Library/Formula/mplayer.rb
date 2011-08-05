require 'formula'

class Mplayer < Formula
  homepage 'http://www.mplayerhq.hu/'
  url 'ftp://ftp.mplayerhq.hu/MPlayer/releases/MPlayer-1.0rc4.tar.bz2'
  md5 '1699c94de39da9c4c5d34e8f58e418f0'

  head 'svn://svn.mplayerhq.hu/mplayer/trunk', :using => StrictSubversionDownloadStrategy

  depends_on 'pkg-config' => :build
  depends_on 'yasm' => :build

  def patches
    # When building from SVN HEAD, configure prompts the user to pull FFmpeg
    # from git.  Don't do that.
    if ARGV.build_head?
      DATA
    elsif `uname -r` =~ /^11\./
      # Lion requires the following diff (which is already fixed in svn trunk)
      "https://raw.github.com/gist/1105164/704c64c97ab7ffcc3e5f69b1c5d4fb0850f572c1/vd_mpng.c.diff"
    end
  end

  def install
    # (A) Do not use pipes, per bug report and MacPorts
    # * https://github.com/mxcl/homebrew/issues/622
    # * http://trac.macports.org/browser/trunk/dports/multimedia/mplayer-devel/Portfile
    # (B) Any kind of optimisation breaks the build
    ENV.gcc_4_2
    ENV['CFLAGS'] = ''
    ENV['CXXFLAGS'] = ''

    system './configure', "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

__END__
diff --git a/configure b/configure
index ef60340..0b24e73 100755
--- a/configure
+++ b/configure
@@ -48,8 +48,6 @@
   fi
 
   if ! test -e ffmpeg ; then
-    echo "No FFmpeg checkout, press enter to download one with git or CTRL+C to abort"
-    read tmp
     if ! git clone --depth 1 git://git.videolan.org/ffmpeg.git ffmpeg ; then
       rm -rf ffmpeg
       echo "Failed to get a FFmpeg checkout"

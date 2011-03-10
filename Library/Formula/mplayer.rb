require 'formula'

class Mplayer <Formula
  homepage 'http://www.mplayerhq.hu/'
  # https://github.com/mxcl/homebrew/issues/issue/87
  head 'svn://svn.mplayerhq.hu/mplayer/trunk', :using => StrictSubversionDownloadStrategy

  depends_on 'pkg-config' => :build
  depends_on 'yasm' => :optional

  def patches
    # configure prompts the user to pull ffmpeg from git.
    # Don't do that.
    DATA
  end

  def install
    # Do not use pipes, per bug report
    # https://github.com/mxcl/homebrew/issues#issue/622
    # and MacPorts
    # http://trac.macports.org/browser/trunk/dports/multimedia/mplayer-devel/Portfile
    # any kind of optimisation breaks the build
    ENV.gcc_4_2
    ENV['CFLAGS'] = ''
    ENV['CXXFLAGS'] = ''

    args = "--prefix=#{prefix}"

    system './configure', *args
    system "make"
    system "make install"
  end
end

__END__
diff --git a/configure b/configure
index ef60340..0b24e73 100755
--- a/configure
+++ b/configure
@@ -48,8 +48,6 @@ if test -e ffmpeg/mp_auto_pull ; then
 fi
 
 if ! test -e ffmpeg ; then
-  echo "No FFmpeg checkout, press enter to download one with git or CTRL+C to abort"
-  read tmp
   if ! git clone --depth 1 git://git.videolan.org/ffmpeg.git ffmpeg ; then
     rm -rf ffmpeg
     echo "Failed to get a FFmpeg checkout"

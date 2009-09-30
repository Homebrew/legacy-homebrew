require 'brewkit'

class Vice <Formula
  @url='http://www.zimmers.net/anonftp/pub/cbm/crossplatform/emulators/VICE/vice-2.1.tar.gz'
  @homepage='http://www.viceteam.org/'
  @md5='a4cca1aad12e12ac7f37d6c85310ade8'

  def patches
    DATA
  end

  def install
    ENV.libpng
    
    if MACOS_VERSION == 10.6
      # Cannot build this version under 10.6 with LLVM
      ENV.gcc_4_2
    end

    # Update the audio driver for 64 bit, backported from trunk
    inreplace 'src/sounddrv/soundcoreaudio.c',
      "#ifdef __i386__",
      "#if defined(__x86_64__) || defined(__i386__)"
      
    # Disable the zlibtest, we know we have it.
    # Use Cocoa instead of X
    system "./configure", "--prefix=#{prefix}", 
                          "--disable-debug", 
                          "--disable-dependency-tracking",
                          "--with-cocoa",
                          "--without-x",
                          "--disable-zlibtest"
    system "make"
    system "make bindist"
    
    libexec.install Dir['vice-macosx-*/*']
    
    # We could trim down the .app sizes a bit more if we only kept
    # the proper .icns files in the proper .app bundles...
    Pathname.glob libexec+'*.app' do |d|
      appname = File.basename(d, '.app')
  
      Pathname.glob d+'Contents/Resources/x*.icns' do |g|
        if File.basename(g, '.icns') != appname
          File.unlink g
        end
      end
    end
    
    # A better approach to the above would be to modify the
    # make-bindist.sh script to not copy extraneous icons
    # in the first place.
  end
  
  def caveats
    "Cocoa apps for these emulators have been installed to #{libexec}."
  end
end


__END__
--- vice/src/arch/unix/macosx/make-bindist.sh	2009/04/13 09:31:24	20670
+++ vice/src/arch/unix/macosx/make-bindist.sh	2009/09/09 19:44:00	21480
@@ -34,6 +34,8 @@
   BIN_FORMAT=ub
 elif [ x"$BIN_TYPE" = "xexecutable i386" ]; then
   BIN_FORMAT=i386
+elif [ x"$BIN_TYPE" = "x64-bit executable" ]; then
+  BIN_FORMAT=x86_64
 elif [ x"$BIN_TYPE" = "xexecutable ppc" ]; then
   BIN_FORMAT=ppc
 else

require 'formula'

class Vice <Formula
  head 'http://vice-emu.svn.sourceforge.net/svnroot/vice-emu/trunk/vice/', 
          :revision => '21722'
  homepage 'http://www.viceteam.org/'
  version '2.1.22'
  
  def remove_unused_icons
    Pathname.glob libexec+'*.app' do |d|
      appname = File.basename(d, '.app')
  
      Pathname.glob d+'Contents/Resources/x*.icns' do |g|
        File.unlink g if File.basename(g, '.icns') != appname
      end
    end
  end
  
  def install
    ENV.libpng
    # Cannot build with LLVM
    ENV.gcc_4_2

    system "./autogen.sh"
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
    
    remove_unused_icons
  end
  
  def caveats
    "Cocoa apps for these emulators have been installed to #{libexec}."
  end
end

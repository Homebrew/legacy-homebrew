require 'brewkit'

class GhostscriptFonts <Formula
  @url='http://downloads.sourceforge.net/project/gs-fonts/gs-fonts/8.11%20%28base%2035%2C%20GPL%29/ghostscript-fonts-std-8.11.tar.gz'
  @homepage='http://sourceforge.net/projects/gs-fonts/'
  @md5='6865682b095f8c4500c54b285ff05ef6'
end

class Ghostscript <Formula
  @url='http://downloads.sourceforge.net/project/ghostscript/GPL%20Ghostscript/8.70/ghostscript-8.70.tar.bz2'
  @homepage='http://www.ghostscript.com/'
  @md5='526366f8cb4fda0d3d293597cc5b984b'
  
  def install
    # ghostscript configure ignores LDFLAGs apparently
    ENV['LIBS']="-L/usr/X11/lib"
    system "./configure", "--prefix=#{prefix}", "--disable-debug", 
                          # the cups component adamantly installs to /usr so fuck it
                          "--disable-cups"
    # versioned stuff in main tree is pointless for us
    inreplace 'Makefile', '/$(GS_DOT_VERSION)', ''
    system "make install"
    (prefix+'share'+'ghostscript'+'doc').rmtree

    GhostscriptFonts.new.brew do
      Dir.chdir '..'
      (prefix+'share'+'ghostscript').install 'fonts'
    end
    
    (man+'de').rmtree
  end
end

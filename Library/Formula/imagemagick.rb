require 'brewkit'

# some credit to http://github.com/maddox/magick-installer

class Libtiff <Formula
  @url='ftp://ftp.remotesensing.org/libtiff/tiff-3.8.2.tar.gz'
  @homepage='http://www.libtiff.org/'
  @md5='fbb6f446ea4ed18955e2714934e5b698'
end

class Libwmf <Formula
  @url='http://downloads.sourceforge.net/project/wvware/libwmf/0.2.8.4/libwmf-0.2.8.4.tar.gz'
  @homepage='http://wvware.sourceforge.net/libwmf.html'
  @md5='d1177739bf1ceb07f57421f0cee191e0'
end

class LittleCMS <Formula
  @url='http://www.littlecms.com/lcms-1.17.tar.gz'
  @homepage='http://www.littlecms.com/'
  @md5='07bdbb4cfb05d21caa58fe3d1c84ddc1'
end

class Ghostscript <Formula
  @url='http://downloads.sourceforge.net/project/ghostscript/GPL%20Ghostscript/8.70/ghostscript-8.70.tar.bz2'
  @homepage='http://www.ghostscript.com/'
  @md5='526366f8cb4fda0d3d293597cc5b984b'
end

class GhostscriptFonts <Formula
  @url='http://downloads.sourceforge.net/project/gs-fonts/gs-fonts/8.11%20%28base%2035%2C%20GPL%29/ghostscript-fonts-std-8.11.tar.gz'
  @homepage='http://sourceforge.net/projects/gs-fonts/'
  @md5='6865682b095f8c4500c54b285ff05ef6'
end

class Imagemagick <Formula
  @url='ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick-6.5.5-7.tar.bz2'
  @md5='fa6530a56278b0e9b7babf83cdcee82c'
  @homepage='http://www.imagemagick.org'

  def deps
    LibraryDep.new 'jpeg'
  end

  def install
    ENV.libpng
    ENV.deparallelize

    # TODO eventually these will be external optional dependencies
    # but for now I am lazy
    Libtiff.new.brew do
      system "./configure", "--prefix=#{prefix}", "--disable-debug"
      system "make install"
    end
    Libwmf.new.brew do
      system "./configure", "--prefix=#{prefix}", "--disable-debug"
      system "make install"
    end
    LittleCMS.new.brew do
      system "./configure", "--prefix=#{prefix}", "--disable-debug"
      system "make install"
    end
    Ghostscript.new.brew do
      # ghostscript configure ignores LDFLAGs apparently
      ENV['LIBS']="-L/usr/X11/lib"
      system "./configure", "--prefix=#{prefix}", "--disable-debug", 
                            # the cups component adamantly installs to /usr so fuck it
                            "--disable-cups"
      # versioned stuff in main tree is pointless for us
      inreplace 'Makefile', '/$(GS_DOT_VERSION)', ''
      system "make install"
      (prefix+'share'+'ghostscript'+'doc').rmtree
    end
    GhostscriptFonts.new.brew do
      Dir.chdir '..'
      (prefix+'share'+'ghostscript').install 'fonts'
    end

    # versioned stuff in main tree is pointless for us
    inreplace 'configure', '${PACKAGE_NAME}-${PACKAGE_VERSION}', '${PACKAGE_NAME}'

    system "./configure", "--disable-static",
                          "--with-modules",
                          "--without-magick-plus-plus",
                          "--disable-dependency-tracking",
                          "--disable-shared",
                          "--without-maximum-compile-warnings",
                          "--prefix=#{prefix}",
                          "--disable-osx-universal-binary",
                          "--with-gs-font-dir=#{prefix}/share/ghostscript/fonts",
                          "--without-perl" # I couldn't make this compile
    system "make install"

    # We already copy these in
    d=prefix+'share'
    (d+'NEWS.txt').unlink
    (d+'LICENSE').unlink
    (d+'ChangeLog').unlink
    
    (man+'de').rmtree
  end

  def caveats
    "I'm not a heavy user of ImageMagick, so please check everything is installed."
  end
end
require 'formula'

def ghostscript_fonts?
  File.directory? "#{HOMEBREW_PREFIX}/share/ghostscript/fonts"
end

def ghostscript_srsly?
  ARGV.include? '--with-ghostscript'
end

def use_wmf?
  ARGV.include? '--use-wmf'
end

class Graphicsmagick < Formula
  url 'http://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.12/GraphicsMagick-1.3.12.tar.bz2'
  head 'hg://http://graphicsmagick.hg.sourceforge.net:8000/hgroot/graphicsmagick/graphicsmagick'
  homepage 'http://www.graphicsmagick.org/'
  md5 '55182f371f82d5f9367bce04e59bbf25'

  depends_on 'jpeg'
  depends_on 'libwmf' if use_wmf?
  depends_on 'libtiff' => :optional
  depends_on 'little-cms' => :optional
  depends_on 'jasper' => :optional
  depends_on 'ghostscript' => :recommended if ghostscript_srsly?
  depends_on 'xz' => :optional

  fails_with_llvm

  def skip_clean? path
    path.extname == '.la'
  end

  def options
    [
      ['--with-ghostscript', 'Compile against ghostscript (not recommended.)'],
      ['--without-magick-plus-plus', "Don't build C++ library."],
      ['--use-wmf', 'Compile with libwmf support.'],
    ]
  end

  def install
    ENV.x11

    # versioned stuff in main tree is pointless for us
    inreplace 'configure', '${PACKAGE_NAME}-${PACKAGE_VERSION}', '${PACKAGE_NAME}'

    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--enable-shared", "--disable-static"]
    args << "--without-magick-plus-plus" if ARGV.include? '--without-magick-plus-plus'
    args << "--disable-openmp" if MacOS.leopard? # libgomp unavailable
    args << "--with-gslib" if ghostscript_srsly?
    args << "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts" \
              unless ghostscript_fonts?

    system "./configure", *args
    system "make install"
  end
end

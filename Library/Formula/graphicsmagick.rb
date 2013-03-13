require 'formula'

def ghostscript_srsly?
  build.include? 'with-ghostscript'
end

def ghostscript_fonts?
  File.directory? "#{HOMEBREW_PREFIX}/share/ghostscript/fonts"
end

class Graphicsmagick < Formula
  homepage 'http://www.graphicsmagick.org/'
  url 'http://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.17/GraphicsMagick-1.3.17.tar.bz2'
  sha256 'cb4e29543b2912657207016ad4c7a081a96b0e4a4d84520bd74d242b3d9a6a7e'

  head 'hg://http://graphicsmagick.hg.sourceforge.net:8000/hgroot/graphicsmagick/graphicsmagick'

  option 'with-ghostscript', 'Compile against ghostscript (not recommended.)'
  option 'use-tiff', 'Compile with libtiff support.'
  option 'use-cms', 'Compile with little-cms support.'
  option 'use-jpeg2000', 'Compile with jasper support.'
  option 'use-wmf', 'Compile with libwmf support.'
  option 'use-xz', 'Compile with xz support.'
  option 'with-quantum-depth-8', 'Compile with a quantum depth of 8 bit'
  option 'with-quantum-depth-16', 'Compile with a quantum depth of 16 bit'
  option 'with-quantum-depth-32', 'Compile with a quantum depth of 32 bit'
  option 'with-x', 'Compile with X11 support.'
  option 'without-magick-plus-plus', "Don't build C++ library."

  depends_on 'libtool' => :build
  depends_on 'jpeg' => :recommended
  depends_on :libpng
  depends_on :x11 if build.include? 'with-x'

  depends_on 'ghostscript' if ghostscript_srsly?

  depends_on 'libtiff' if build.include? 'use-tiff'
  depends_on 'little-cms2' if build.include? 'use-cms'
  depends_on 'jasper' if build.include? 'use-jpeg2000'
  depends_on 'libwmf' if build.include? 'use-wmf'
  depends_on 'xz' if build.include? 'use-xz'

  fails_with :llvm do
    build 2335
  end

  skip_clean :la

  def install
    # versioned stuff in main tree is pointless for us
    inreplace 'configure', '${PACKAGE_NAME}-${PACKAGE_VERSION}', '${PACKAGE_NAME}'
    # Homebrew cleans ".la" files from lib but this configure looks for them.
    # Maintainers: This will be fixed in the next version >= 1.3.18 (probably)
    # Then the next line will not be needed anymore. Further the --with-ltdl... flags
    # further down can be removed then!
    inreplace 'configure', 'if test -f "$with_ltdl_lib/libltdl.la"', 'if test -f "$with_ltdl_lib/libltdl.a"'

    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--enable-shared", "--disable-static"]
    args << "--without-magick-plus-plus" if build.include? 'without-magick-plus-plus'
    args << "--disable-openmp" if MacOS.version == :leopard or not ENV.compiler == :gcc # libgomp unavailable
    args << "--with-ltdl-include=#{Formula.factory('libtool').opt_prefix}/include"  # avoid to ship it's own ltdl
    args << "--with-ltdl-lib=#{Formula.factory('libtool').opt_prefix}/lib"  # avoid to ship it's own ltdl
    args << "--with-gslib" if ghostscript_srsly?
    args << "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts" \
              unless ghostscript_fonts?

    if build.include? 'with-quantum-depth-32'
      quantum_depth = 32
    elsif build.include? 'with-quantum-depth-16'
      quantum_depth = 16
    elsif build.include? 'with-quantum-depth-8'
      quantum_depth = 8
    end

    args << "--with-quantum-depth=#{quantum_depth}" if quantum_depth
    args << "--without-x" unless build.include? 'with-x'

    system "./configure", *args
    system "make install"
  end

  def test
    system "#{bin}/gm", "identify", \
      "/System/Library/Frameworks/SecurityInterface.framework/Versions/A/Resources/Key_Large.png"
  end
end

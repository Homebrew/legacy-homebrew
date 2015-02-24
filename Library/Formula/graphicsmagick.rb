require 'formula'

class Graphicsmagick < Formula
  homepage 'http://www.graphicsmagick.org/'
  url 'https://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.20/GraphicsMagick-1.3.20.tar.bz2'
  sha256 '7caf27691ec21682de1f0259c9243725db7cdeca699c40958c28aece99e4f1dc'
  head 'http://graphicsmagick.hg.sourceforge.net:8000/hgroot/graphicsmagick/graphicsmagick', :using => :hg

  bottle do
    sha1 "3e681ecf2e126ee5322a6c05e4228670de8b7f8e" => :mavericks
    sha1 "6dbabb0a513590f9e000bdf6a9fc4cf15cc829ec" => :mountain_lion
    sha1 "dbdef094a39a8052eb7b04bae77724b5c7c524e9" => :lion
  end

  option 'with-quantum-depth-8', 'Compile with a quantum depth of 8 bit'
  option 'with-quantum-depth-16', 'Compile with a quantum depth of 16 bit'
  option 'with-quantum-depth-32', 'Compile with a quantum depth of 32 bit'
  option 'without-magick-plus-plus', 'disable build/install of Magick++'
  option 'without-svg', 'Compile without svg support'
  option 'with-perl', 'Build PerlMagick; provides the Graphics::Magick module'

  depends_on "libtool" => :run

  depends_on 'pkg-config' => :build

  depends_on 'jpeg' => :recommended
  depends_on 'libpng' => :recommended
  depends_on 'freetype' => :recommended

  depends_on :x11 => :optional
  depends_on 'libtiff' => :optional
  depends_on 'little-cms' => :optional
  depends_on 'little-cms2' => :optional
  depends_on 'jasper' => :optional
  depends_on 'libwmf' => :optional
  depends_on 'ghostscript' => :optional

  fails_with :llvm do
    build 2335
  end

  skip_clean :la

  def ghostscript_fonts?
    File.directory? "#{HOMEBREW_PREFIX}/share/ghostscript/fonts"
  end

  def install
    args = [ "--prefix=#{prefix}",
             "--disable-dependency-tracking",
             "--enable-shared",
             "--disable-static",
             "--with-modules",
             "--disable-openmp"]

    args << "--without-gslib" if build.without? 'ghostscript'
    args << "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts" if build.without? 'ghostscript'
    args << "--without-magick-plus-plus" if build.without? 'magick-plus-plus'
    args << "--with-perl" if build.with? "perl"

    if build.with? 'quantum-depth-32'
      quantum_depth = 32
    elsif build.with? 'quantum-depth-16'
      quantum_depth = 16
    elsif build.with? 'quantum-depth-8'
      quantum_depth = 8
    end

    args << "--with-quantum-depth=#{quantum_depth}" if quantum_depth
    args << "--without-x" if build.without? 'x11'
    args << "--without-ttf" if build.without? 'freetype'
    args << "--without-xml" if build.without? 'svg'
    args << "--without-lcms" if build.without? 'little-cms'
    args << "--without-lcms2" if build.without? 'little-cms2'

    # versioned stuff in main tree is pointless for us
    inreplace 'configure', '${PACKAGE_NAME}-${PACKAGE_VERSION}', '${PACKAGE_NAME}'
    system "./configure", *args
    system "make", "install"
    if build.with? "perl"
      cd 'PerlMagick' do
        # Install the module under the GraphicsMagick prefix
        system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}"
        system "make"
        system "make", "install"
      end
    end
  end

  test do
    system "#{bin}/gm", "identify", test_fixtures("test.png")
  end

  def caveats
    if build.with? "perl"
      <<-EOS.undent
        The Graphics::Magick perl module has been installed under:

          #{lib}

      EOS
    end
  end
end

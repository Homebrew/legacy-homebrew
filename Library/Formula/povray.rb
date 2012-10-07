require 'formula'

class NeedsLion < Requirement
  def satisfied?
    MacOS.version >= :lion
  end
  def message
    "PovRay 3.7.0.RC6 requires Mac OS X 10.7 or newer"
  end
  def fatal?
    true
  end
end

class Povray < Formula
  homepage 'http://www.povray.org/'
  url 'http://www.povray.org/beta/source/povray-3.7.0.RC6.tar.gz'
  sha256 '374957bdb90fb7be5f36f839b3f04ab0a4340f6e8cf369f658d6592a342803e3'
  version '3.7.0.RC6'

  option 'use-openexr', 'Compile with OpenEXR support.'
  option 'use-zlib',    'Compile with zlib support.'

  depends_on NeedsLion.new
  depends_on 'boost'
  depends_on 'jpeg'
  depends_on 'libpng'
  depends_on 'libtiff'
  depends_on 'openexr' => :optional if build.include? 'use-openexr'

  def patches
    {:p0 => [
       "http://svn.macports.org/repository/macports/trunk/dports/graphics/povray/files/patch-boost-1.50.diff",
       "http://svn.macports.org/repository/macports/trunk/dports/graphics/povray/files/patch-configure-stat.diff",
       "http://svn.macports.org/repository/macports/trunk/dports/graphics/povray/files/patch-lseek64.diff",
       "http://svn.macports.org/repository/macports/trunk/dports/graphics/povray/files/patch-vfe-uint.diff" 
    ]}

  end

  def install
    
    # while this is RC6, the code still says RC5, so update to reflect that
    inreplace [ 'VERSION', 'configure' ], '3.7.0.RC5', '3.7.0.RC6'

    # include the boost system library to resolve compilation conflicts
    ENV["LIBS"] = "-lboost_system-mt"

    args = [ 
             "COMPILED_BY=homebrew",
             "--disable-debug", 
             "--disable-dependency-tracking",
             "--prefix=#{prefix}",
             "--mandir=#{man}",
           ]

    args << "--with-openexr=${HOMEBREW_PREFIX}" if build.include? "use-openexr"
    args << "--with-zlib=${HOMEBREW_PREFIX}"    if build.include? "use-zlib"

    system "./configure", *args 
    system "make install"
  end

  def test
    ohai "Rendering all test scenes; this may take a while"
    mktemp do
      system "#{share}/povray-3.7.0.RC6/scripts/allscene.sh", "-o", "."
    end
  end
end

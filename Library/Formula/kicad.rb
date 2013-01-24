require 'formula'

class KicadLibrary < Formula
  homepage 'https://code.launchpad.net/~kicad-lib-committers/kicad/library'
  url 'https://code.launchpad.net/~kicad-lib-committers/kicad/library', :using => :bzr
  version 'HEAD'

  def initialize; super 'kicad-library'; end
end

class Kicad < Formula
  homepage 'https://launchpad.net/kicad'
  url "http://bazaar.launchpad.net/~kicad-testing-committers/kicad/testing/", :revision => '3920', :using => :bzr
  head "http://bazaar.launchpad.net/~kicad-testing-committers/kicad/testing/", :using => :bzr
  version 'testing-3920'

  depends_on 'cmake' => :build
  depends_on :x11
  depends_on 'Wxmac'

  def patches
    [
    # fixes wx-config not requiring aui module
    "https://gist.github.com/raw/4602653/0e4397884062c8fc44a9627e78fb4d2af20eed5b/gistfile1.txt",
    # enable retina display for OSX
    "https://gist.github.com/raw/4602849/2fe826c13992c4238a0462c03138f4c6aabd4968/gistfile1.txt"
    ]
  end

  def install

    # install the component libraries
    KicadLibrary.new.brew do
      args = std_cmake_args + %W[
        -DKICAD_MODULES=#{share}/kicad/modules
        -DKICAD_LIBRARY=#{share}/kicad/library
      ]
      system "cmake", ".", *args
      system "make install"
    end

    if build.devel?
      args = std_cmake_args + %W[
        -DKICAD_TESTING_VERSION=ON
        -DCMAKE_CXX_FLAGS=-D__ASSERTMACROS__
      ]
    else
      args = std_cmake_args + %W[
        -DKICAD_STABLE_VERSION=ON
        -DCMAKE_CXX_FLAGS=-D__ASSERTMACROS__
      ]
    end

    system "cmake", ".", *args

    # fix the osx search path for the library components to the homebrew directory
    inreplace 'common/edaappl.cpp','/Library/Application Support/kicad', "#{HOMEBREW_PREFIX}/share/kicad"

    system "make install"
  end

  def caveats; <<-EOS.undent
    kicad.app and friends installed to:
      #{bin}

    To link the application to a normal Mac OS X location:
        brew linkapps
    or:
        ln -s #{bin}/bitmap2component.app /Applications
        ln -s #{bin}/cvpcb.app /Applications
        ln -s #{bin}/eeschema.app /Applications
        ln -s #{bin}/gerbview.app /Applications
        ln -s #{bin}/kicad.app /Applications
        ln -s #{bin}/pcb_calculation.app /Applications
        ln -s #{bin}/pcbnew.app /Applications
    EOS
  end

  def test
    # run main kicad UI
    system "open #{bin}/kicad.app"
  end
end

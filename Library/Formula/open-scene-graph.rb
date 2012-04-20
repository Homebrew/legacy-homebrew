require 'formula'

class OpenSceneGraph < Formula
  homepage 'http://www.openscenegraph.org/projects/osg'
  url 'http://www.openscenegraph.org/downloads/stable_releases/OpenSceneGraph-3.0.1/source/OpenSceneGraph-3.0.1.zip'
  md5 'c43a25d023e635c3566b2083d8e6d956'
  head 'http://www.openscenegraph.org/svn/osg/OpenSceneGraph/trunk/'

  depends_on 'cmake' => :build
  depends_on 'jpeg'
  depends_on 'wget'
  depends_on 'ffmpeg' => :optional
  depends_on 'gdal' => :optional
  depends_on 'jasper' => :optional
  depends_on 'openexr' => :optional
  depends_on 'dcmtk' => :optional
  depends_on 'librsvg' => :optional
  depends_on 'collada-dom' => :optional

  fails_with :clang do
    build 318
    cause <<-EOS.undent
      cannot initialize a parameter of type 'void *' with an lvalue of type 'const void *const'
      http://forum.openscenegraph.org/viewtopic.php?t=10042
      EOS
  end

  def patches
    [
      # The mini-Boost finder in FindCOLLADA doesn't find our boost, so fix it.
      "https://raw.github.com/gist/2430359/55ff8ac017605e34aa36985d10d8df17ee370630/mini-Boost.patch",
      # Lion replacement for CGDisplayBitsPerPixel(); 
      # taken from: http://www.openscenegraph.org/projects/osg/changeset/12790/OpenSceneGraph/trunk/src/osgViewer/DarwinUtils.mm
      # Issue at: https://github.com/mxcl/homebrew/issues/11391
      # should be obsolete with some newer versions  (curren version is: 3.0.1)
      "https://raw.github.com/gist/2430312/1be93c56169b43b66beb84a2b05538b335674f4b/displayBitsPerPixel_OSX10_7.patch"
    ]
  end

  def install
    args = %W{
      ..
      -DCMAKE_INSTALL_PREFIX='#{prefix}'
      -DCMAKE_BUILD_TYPE=None
      -Wno-dev
      -DBUILD_OSG_WRAPPERS=ON
      -DBUILD_DOCUMENTATION=ON
    }

    if snow_leopard_64?
      args << "-DCMAKE_OSX_ARCHITECTURES=x86_64"
      args << "-DOSG_DEFAULT_IMAGE_PLUGIN_FOR_OSX=imageio"
      args << "-DOSG_WINDOWING_SYSTEM=Cocoa"
    else
      args << "-DCMAKE_OSX_ARCHITECTURES=i386"
    end

    if Formula.factory('collada-dom').installed?
      args << "-DCOLLADA_INCLUDE_DIR=#{HOMEBREW_PREFIX}/include/collada-dom"
    end

    mkdir "build" do
      system "cmake", *args
      system "make install"
    end
  end

end



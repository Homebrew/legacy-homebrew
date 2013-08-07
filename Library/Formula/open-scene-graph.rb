require 'formula'

class OpenSceneGraph < Formula
  homepage 'http://www.openscenegraph.org/projects/osg'
  url 'http://trac.openscenegraph.org/downloads/developer_releases/OpenSceneGraph-3.2.0.zip'
  sha1 'c20891862b5876983d180fc4a3d3cfb2b4a3375c'

  head 'http://www.openscenegraph.org/svn/osg/OpenSceneGraph/trunk/'

  option 'docs', 'Build the documentation with Doxygen and Graphviz'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on 'wget'
  depends_on 'gtkglext'
  depends_on 'gdal' => :optional
  depends_on 'jasper' => :optional
  depends_on 'openexr' => :optional
  depends_on 'dcmtk' => :optional
  depends_on 'librsvg' => :optional
  depends_on 'collada-dom' => :optional
  depends_on 'gnuplot' => :optional
  depends_on 'ffmpeg' => :optional

  if build.include? 'docs'
    depends_on 'doxygen'
    depends_on 'graphviz'
  end

  def install
    # Turning off FFMPEG takes this change or a dozen "-DFFMPEG_" variables
    unless build.with? 'ffmpeg'
      inreplace 'CMakeLists.txt', 'FIND_PACKAGE(FFmpeg)', '#FIND_PACKAGE(FFmpeg)'
    end

    args = std_cmake_args
    args << '-DBUILD_DOCUMENTATION=' + ((build.include? 'docs') ? 'ON' : 'OFF')

    if MacOS.prefer_64_bit?
      args << "-DCMAKE_OSX_ARCHITECTURES=x86_64"
      args << "-DOSG_DEFAULT_IMAGE_PLUGIN_FOR_OSX=imageio"
      args << "-DOSG_WINDOWING_SYSTEM=Cocoa"
    else
      args << "-DCMAKE_OSX_ARCHITECTURES=i386"
    end

    if Formula.factory('collada-dom').installed?
      args << "-DCOLLADA_INCLUDE_DIR=#{HOMEBREW_PREFIX}/include/collada-dom"
    end

    args << '..'

    mkdir 'build' do
      system 'cmake', *args
      system 'make'
      system 'make', 'doc_openscenegraph' if build.include? 'docs'
      system 'make install'
      if build.include? 'docs'
        doc.install Dir["#{prefix}/doc/OpenSceneGraphReferenceDocs/*"]
      end
    end
  end
end

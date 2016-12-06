require 'formula'

class OgreTools < Formula
  homepage 'http://www.ogre3d.org/'
  url 'http://downloads.sourceforge.net/project/ogre/ogre/1.8/1.8.1/ogre_src_v1-8-1.tar.bz2'
  sha1 'd6153cacda24361a81e7d0a6bf9aa641ad9dd650'
  version '1.8.1'

  depends_on 'cmake' => :build
  depends_on 'libogremain'

  option :universal

  def install
    args = []

    args << "-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}"
    args << "-DCMAKE_BUILD_TYPE:STRING=Release"

    args << "-DOGRE_STATIC:BOOL=ON"
    args << "-DOGRE_INSTALL_PLUGIN_HEADERS:BOOL=OFF"

    args << "-DCMAKE_OSX_ARCHITECTURES:STRING='i386;x86_64'" if build.universal?

    args << "-DOGRE_BUILD_SAMPLES:BOOL=OFF"
    args << "-DOGRE_BUILD_TOOLS:BOOL=ON"
    args << "-DOGRE_INSTALL_TOOLS:BOOL=ON"

    args << "-DOGRE_CONFIG_THREADS:INT=0"

    args << "-DOGRE_BUILD_COMPONENT_PAGING:BOOL=NO"
    args << "-DOGRE_BUILD_COMPONENT_PROPERTY:BOOL=NO"
    args << "-DOGRE_BUILD_COMPONENT_TERRAIN:BOOL=NO"

    args << "-DOGRE_BUILD_PLUGIN_BSP:BOOL=NO"
    args << "-DOGRE_BUILD_PLUGIN_CG:BOOL=NO"
    args << "-DOGRE_BUILD_PLUGIN_OCTREE:BOOL=NO"
    args << "-DOGRE_BUILD_PLUGIN_PCZ:BOOL=NO"
    args << "-DOGRE_BUILD_PLUGIN_PFX:BOOL=NO"

    args << "-DOGRE_BUILD_RENDERSYSTEM_GLES:BOOL=NO"
    args << "-DOGRE_BUILD_RENDERSYSTEM_GL:BOOL=NO"

    args << "-DOGRE_INSTALL_DEPENDENCIES:BOOL=NO"
    args << "-DOGRE_COPY_DEPENDENCIES:BOOL=NO"
    args << '.'

    system "cmake", *args
    system "make"
    system "make install"

    system "rm", "-rf", "#{prefix}/include", "#{prefix}/lib"
  end
end


require 'formula'

class Libogremain < Formula
  homepage 'http://www.ogre3d.org/'
  url 'http://downloads.sourceforge.net/project/ogre/ogre/1.8/1.8.1/ogre_src_v1-8-1.tar.bz2'
  sha1 'd6153cacda24361a81e7d0a6bf9aa641ad9dd650'
  version '1.8.1'

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'freetype'
  depends_on 'freeimage'
  depends_on 'libzip'
  depends_on 'libzzip'

  option :universal
  option 'static',              'Build static library (including plugins)'
  option 'double-precision',    'Build Ogre with double precision support'
  option 'threads-preparation', 'Build Ogre with support for background resource preparation (implied by --threads)'
  option 'threads',             'Build Ogre with full background loading support'

  option 'no-component-paging',   'Excludes the optional Paging component'
  option 'no-component-property', 'Excludes the optional Property component'
  option 'no-component-terrain',  'Excludes the optional Terrain component'

  option 'no-plugin-bsp',         'Excludes the BSP scene manager plugin'
  option 'no-plugin-cg',          'Excludes the nVidia Cg plugin'
  option 'no-plugin-octree',      'Excludes the Octree scene manager plugin'
  option 'no-plugin-pcz',         'Excludes the Portal-Connected Zone scene manager plugin'
  option 'no-plugin-pfx',         'Excludes the ParticleFX plugin'

  option 'with-rendersystem-gles',  'Includes the OpenGLES sender system'


  def install
    args = []

    args << "-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}"
    args << "-DCMAKE_BUILD_TYPE:STRING=Release"

    args << "-DOGRE_STATIC:BOOL=ON" if build.include? "static"
    args << "-DOGRE_INSTALL_PLUGIN_HEADERS:BOOL=ON" if build.include? "static"

    args << "-DCMAKE_OSX_ARCHITECTURES:STRING='i386;x86_64'" if build.universal?

    args << "-DOGRE_BUILD_SAMPLES:BOOL=OFF"
    args << "-DOGRE_BUILD_TOOLS:BOOL=OFF"

    args << "-DOGRE_CONFIG_DOUBLE:BOOL=ON" if build.include? 'double-precision'

    if build.include? 'threads'
    	args << "-DOGRE_CONFIG_THREADS:INT=1"
    elsif build.include? 'threads-preparation'
    	args << "-DOGRE_CONFIG_THREADS:INT=2"
    else
    	args << "-DOGRE_CONFIG_THREADS:INT=0"
    end

    args << "-DOGRE_BUILD_COMPONENT_PAGING:BOOL="   + ((build.include? 'no-component-paging')   ? 'NO' : 'YES')
    args << "-DOGRE_BUILD_COMPONENT_PROPERTY:BOOL=" + ((build.include? 'no-component-property') ? 'NO' : 'YES')
    args << "-DOGRE_BUILD_COMPONENT_TERRAIN:BOOL="  + ((build.include? 'no-component-terrain')  ? 'NO' : 'YES')

    args << "-DOGRE_BUILD_PLUGIN_BSP:BOOL="    + ((build.include? 'no-plugin-bsp')    ? 'NO' : 'YES')
    args << "-DOGRE_BUILD_PLUGIN_CG:BOOL="     + ((build.include? 'no-plugin-cg')     ? 'NO' : 'YES')
    args << "-DOGRE_BUILD_PLUGIN_OCTREE:BOOL=" + ((build.include? 'no-plugin-octree') ? 'NO' : 'YES')
    args << "-DOGRE_BUILD_PLUGIN_PCZ:BOOL="    + ((build.include? 'no-plugin-pcz')    ? 'NO' : 'YES')
    args << "-DOGRE_BUILD_PLUGIN_PFX:BOOL="    + ((build.include? 'no-plugin-pfx')    ? 'NO' : 'YES')

    args << "-DOGRE_BUILD_RENDERSYSTEM_GLES:BOOL=" + ((build.include? 'with-rendersystem-gles') ? 'YES' : 'NO')
    args << "-DOGRE_BUILD_RENDERSYSTEM_GL:BOOL=YES"

    args << "-DOGRE_INSTALL_DEPENDENCIES:BOOL=NO"
    args << "-DOGRE_COPY_DEPENDENCIES:BOOL=NO"
    args << '.'

    system "cmake", *args
    system "make"
    system "make install"
  end
end


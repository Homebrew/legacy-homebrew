require 'formula'

class Vtp < Formula
  homepage 'http://vterrain.org'

  url 'http://vtp.googlecode.com/svn/!svn/bc/7827/trunk/', :using => :curl
  head 'http://vtp.googlecode.com/svn/trunk/'

  depends_on 'cmake' => :build
  depends_on 'wxwidgets'
  depends_on 'gdal'
  depends_on 'libmini'
  depends_on 'open-scene-graph'

  def install
    
    mkdir 'build' do
      system 'cmake', '..', *std_cmake_args
      system 'make'
      system 'make install'
    end

  end
end

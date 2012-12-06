require 'formula'

class Vv < Formula
  homepage 'http://www.creatis.insa-lyon.fr/rio/vv/'
  url 'http://www.creatis.insa-lyon.fr/rio/vv?action=AttachFile&do=get&target=vvSource-1.3.tar.gz'
  version '1.3'
  head 'git://git.creatis.insa-lyon.fr/clitk'
  sha1 '101687023788aed297ea4d8ebb601c9ac1be4378'

  option 'with-tools', "Build additional command-line tools" 
  option 'with-segmentation', "Build additional command-line segmentation tools" 
  
  depends_on 'cmake' => :build
  depends_on 'insighttoolkit'
  depends_on 'vtk'
  depends_on 'qt'

  def install
    args = std_cmake_args
    args << "-DCMAKE_BUILD_TYPE=Release"  
    args << "-DCLITK_BUILD_TOOLS=ON" if build.include? 'with-tools'
    args << "-DCLITK_BUILD_SEGMENTATION=ON" if build.include? 'with-segmentation'
  
    mkdir 'build' do
      system "cmake", "..", *args
      system "make"
      system "make install" 
    end
  end
end

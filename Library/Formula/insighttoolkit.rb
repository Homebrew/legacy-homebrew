require 'formula'

class Insighttoolkit < Formula
  homepage 'http://www.itk.org'
  url 'http://sourceforge.net/projects/itk/files/itk/4.2/InsightToolkit-4.2.0.tar.gz'
  sha1 '5d1fb109cc8b8648772b654f898a531d9af01e38'
  head 'git://itk.org/ITK.git'

  depends_on 'cmake' => :build

  option 'examples',  'Compile and install various examples'

  def install
    args = std_cmake_args + %W[
      -DBUILD_TESTING=OFF
      -DBUILD_SHARED_LIBS=ON
    ]
    args << ".."
    args << '-DBUILD_EXAMPLES=' + ((build.include? 'examples') ? 'ON' : 'OFF')
    
    mkdir 'itk-build' do
      system "cmake", *args
      system "make install"
    end
  end
end

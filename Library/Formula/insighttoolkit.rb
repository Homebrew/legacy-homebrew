require 'formula'

class Insighttoolkit < Formula
  homepage 'http://www.itk.org'
  url 'http://sourceforge.net/projects/itk/files/itk/4.3/InsightToolkit-4.3.1.tar.gz'
  sha1 '85375a316dd39f7f70dee5a2bd022f768db28eeb'

  head 'git://itk.org/ITK.git'

  option 'examples', 'Compile and install various examples'
  option 'with-opencv-bridge', 'Include OpenCV bridge'

  depends_on 'cmake' => :build

  def install
    args = std_cmake_args + %W[
      -DBUILD_TESTING=OFF
      -DBUILD_SHARED_LIBS=ON
    ]
    args << ".."
    args << '-DBUILD_EXAMPLES=' + ((build.include? 'examples') ? 'ON' : 'OFF')
    args << '-DModule_ITKVideoBridgeOpenCV=' + ((build.include? 'with-opencv-bridge') ? 'ON' : 'OFF')

    mkdir 'itk-build' do
      system "cmake", *args
      system "make install"
    end
  end
end

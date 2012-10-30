require 'formula'

class Insighttoolkit < Formula
  homepage 'http://www.itk.org'
  url 'http://sourceforge.net/projects/itk/files/itk/4.2/InsightToolkit-4.2.1.tar.gz'
  sha1 'f500cd7e2e79a1025863d9adc60cf8de7433402e'

  head 'git://itk.org/ITK.git'

  option 'examples', 'Compile and install various examples'

  depends_on 'cmake' => :build

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

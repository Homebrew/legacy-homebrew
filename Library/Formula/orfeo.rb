require 'formula'

class Orfeo < Formula
  homepage 'http://www.orfeo-toolbox.org/otb/'
  url 'http://sourceforge.net/projects/orfeo-toolbox/files/OTB/OTB-3.14.1/OrfeoToolbox-3.14.1.tgz'
  sha1 '2cdef44fc4119ef410f750001c18aabc6be3a48c'

  depends_on 'cmake' => :build
  depends_on 'fltk'
  depends_on 'gdal'
  depends_on 'qt'

  option 'examples', 'Compile and install various examples'
  option 'python', 'Enable Python support'
  option 'java', 'Enable Java support'
  option 'patented', 'Enable patented algorithms'

  def install
    args = std_cmake_args + %W[
      -DBUILD_APPLICATIONS=ON
      -DOTB_USE_EXTERNAL_FLTK=ON
      -DBUILD_TESTING=OFF
      -DBUILD_SHARED_LIBS=ON
      -DOTB_WRAP_QT=ON
    ]

    args << '-DBUILD_EXAMPLES=' + ((build.include? 'examples') ? 'ON' : 'OFF')
    args << '-DOTB_WRAP_PYTHON=' + ((build.include? 'python') ? 'ON' : 'OFF')
    args << '-DOTB_WRAP_JAVA=' + ((build.include? 'java') ? 'ON' : 'OFF')
    args << '-DOTB_USE_PATENTED=' + ((build.include? 'patented') ? 'ON' : 'OFF')

    mkdir 'build' do
      system 'cmake', '..', *args
      system 'make'
      system 'make install'
    end
  end
end

require 'formula'

class Dgtal < Formula
  homepage 'http://liris.cnrs.fr/dgtal'
  url 'http://liris.cnrs.fr/dgtal/releases/DGtal-0.5.1-Source.tar.gz'
  sha1 'ab3e70186b3d1da1a698d3407e3603c69951e0f0'

  head 'https://github.com/DGtal-team/DGtal.git'

  option 'with-cairo', "Enable cairographics in DGtal"
  option 'with-gmp', "Enable GNU Multiple Precision Arithmetic Library in DGtal"
  option 'with-qglview', "Enable QGLViewer vizualisation"
  option 'with-magick', "Enable GraphicsMagick for 2d image readers"

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'gmp' if build.include? 'with-gmp'
  depends_on 'cairo' if build.include? 'with-cairo'
  depends_on 'libqglviewer' if build.include? 'with-qglviewer'
  depends_on 'graphicsmagick' if build.include? 'with-magick'

  def install
    args = std_cmake_args
    args << "-DCMAKE_BUILD_TYPE=Release"
    args << "-DBUILD_EXAMPLES=OFF"
    args << "-DWITH_C11:bool=false"

    args << "-DWITH_GMP=ON" if build.include? 'with-gmp'
    args << "-DWITH_CAIRO=ON" if build.include? 'with-cairo'
    args << "-DWITH_QGLVIEWER=ON" if build.include? 'with-qglviewer'

    mkdir 'build' do
      system "cmake", "..", *args
      system "make"
      system "make install"
    end
  end
end

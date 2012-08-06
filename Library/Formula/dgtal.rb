require 'formula'

class Dgtal < Formula
  homepage 'http://liris.cnrs.fr/dgtal'
  url 'http://liris.cnrs.fr/dgtal/releases/DGtal-0.5.1-Source.tar.gz'
  sha1 'ab3e70186b3d1da1a698d3407e3603c69951e0f0'
  head 'https://github.com/DGtal-team/DGtal.git'
  
  depends_on 'cmake' => :build
  depends_on 'boost' 
  depends_on 'gmp' if ARGV.include? '--with-gmp'
  depends_on 'cairo' if ARGV.include? '--with-cairo'
  depends_on 'libqglviewer' if ARGV.include? '--with-qglviewer'
  depends_on 'graphicsmagick' if ARGV.include? '--with-magick'

  def options
    [
     ['--with-cairo', "Enable cairographics in DGtal"],
     ['--with-gmp', "Enable GNU Multiple Precision Arithmetic Library in DGtal"],
     ['--with-qglview', "Enable QGLViewer vizualisation"],
     ['--with-magick', "Enable GraphicsMagick for 2d image readers"]
    ]
  end

  def install
    args = ['']
    args << std_cmake_args
    args << "-DCMAKE_BUILD_TYPE=Release"
    args << "-DBUILD_EXAMPLES=OFF"
    args << "-DWITH_C11:bool=false"
    if ARGV.include? '--with-gmp'
      args << "-DWITH_GMP=ON"
    end
    if ARGV.include? '--with-cairo'
      args << "-DWITH_CAIRO=ON"
    end
    if ARGV.include? '--with-qglviewer'
      args << "-DWITH_QGLVIEWER=ON"
    end
    args << '.'
    system "cmake", *args
    system "make"
    system "make install" 
  end

  def test
    system "false"
  end
end

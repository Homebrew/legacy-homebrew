require 'formula'

class Dgtal < Formula
  homepage 'http://libdgtal.org'
  url 'http://liris.cnrs.fr/dgtal/releases/DGtal-0.6.0-Source.tar.gz'
  sha1 '7eebf636bb356fe7672eed8295647ca9a36c452d'

  head 'https://github.com/DGtal-team/DGtal.git'

  option 'with-qglview', "Enable QGLViewer vizualisation"
  option 'with-magick', "Enable GraphicsMagick for 2d image readers"

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'gmp' => :optional
  depends_on 'cairo' => :optional
  depends_on 'libqglviewer' if build.with? 'qglviewer'
  depends_on 'graphicsmagick' if build.with? 'magick'

  def install
    args = std_cmake_args
    args << "-DCMAKE_BUILD_TYPE=Release"
    args << "-DBUILD_EXAMPLES=OFF"
    args << "-DDGTAL_BUILD_TESTING=OFF"
    args << "-DWITH_C11:bool=false"

    args << "-DWITH_GMP=ON" if build.with? 'gmp'
    args << "-DWITH_CAIRO=ON" if build.with? 'cairo'
    args << "-DWITH_QGLVIEWER=ON" if build.with? 'qglviewer'

    mkdir 'build' do
      system "cmake", "..", *args
      system "make"
      system "make install"
    end
  end
end

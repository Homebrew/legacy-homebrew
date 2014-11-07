require 'formula'

class Dgtal < Formula
  homepage 'http://libdgtal.org'
  url 'http://liris.cnrs.fr/dgtal/releases/DGtal-0.8.0-Source.tar.gz'
  sha1 '61c8d4b7db2c31daed9456ab65b0158d0a0e1bab'
  head 'https://github.com/DGtal-team/DGtal.git'

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'gmp' => :optional
  depends_on 'cairo' => :optional
  depends_on 'libqglviewer' => :optional
  depends_on 'graphicsmagick' => :optional
  depends_on 'eigen' => :optional
  depends_on "cgal" => [:optional, "with-eigen3"].

  deprecated_option "with-magick" => "with-graphicsmagick"
  deprecated_option "with-qglviewer" => "with-libqglviewer"
  
  def install
    args = std_cmake_args
    args << "-DCMAKE_BUILD_TYPE=Release"
    args << "-DBUILD_EXAMPLES=OFF"
    args << "-DDGTAL_BUILD_TESTING=OFF"
    args << "-DWITH_C11:bool=false"

    args << "-DWITH_GMP=ON" if build.with? 'gmp'
    args << "-DWITH_CAIRO=ON" if build.with? 'cairo'
    args << "-DWITH_QGLVIEWER=ON" if build.with? 'libqglviewer'
    args << "-DWITH_EIGEN=ON" if build.with? 'eigen'
    args << "-DWITH_MAGICK=ON" if build.with? 'graphicsmagick'
    args << "-DWITH_CGAL=ON -DWITH_EIGEN=ON -DWITH_GMP=ON" if build.with? 'cgal'

    mkdir 'build' do
      system "cmake", "..", *args
      system "make"
      system "make install"
    end
  end
end

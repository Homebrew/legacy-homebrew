require 'formula'

class Dgtal < Formula
  homepage 'http://libdgtal.org'
  url 'http://liris.cnrs.fr/dgtal/releases/DGtal-0.8.0-Source.tar.gz'
  sha1 '61c8d4b7db2c31daed9456ab65b0158d0a0e1bab'
  head 'https://github.com/DGtal-team/DGtal.git'

  bottle do
    sha1 "1b4c350945e664552202155c20b26f0ca28c7637" => :yosemite
    sha1 "44fcfb0d5ba7f1d05f504dad9ec92cd63d6b6b0c" => :mavericks
    sha1 "7f779f3f7d6dae2936ca1e160b84863f42d4eb15" => :mountain_lion
  end

  depends_on 'cmake' => :build
  boost_args = []; boost_args << "c++11" if MacOS.version < "10.9";
  depends_on "boost" => boost_args
  depends_on 'gmp' => :optional
  depends_on 'cairo' => :optional
  depends_on 'libqglviewer' => :optional
  depends_on 'graphicsmagick' => :optional
  depends_on 'eigen' => :optional
  depends_on "cgal" => [:optional, "with-eigen3"]

  deprecated_option 'with-magick' => 'with-graphicsmagick'
  deprecated_option 'with-qglviewer' => 'with-libqglviewer'

  # Bugfix for boost 1.57: https://github.com/DGtal-team/DGtal/issues/938
  patch do
    url "https://github.com/dcoeurjo/DGtal/commit/c676dc82d8d959377622a61ceab6354bab7a2baa.diff"
    sha1 "ef878791a0e31a006f88ea4366344108bf2a4db8"
  end

  needs :cxx11

  def install
    ENV.cxx11
    args = std_cmake_args
    args << "-DCMAKE_BUILD_TYPE=Release"
    args << "-DBUILD_EXAMPLES=OFF"
    args << "-DDGTAL_BUILD_TESTING=OFF"

    args << "-DWITH_GMP=true" if build.with? 'gmp'
    args << "-DWITH_CAIRO=true" if build.with? 'cairo'
    args << "-DWITH_QGLVIEWER=true" if build.with? 'libqglviewer'
    args << "-DWITH_EIGEN=true" if build.with? 'eigen'
    args << "-DWITH_MAGICK=true" if build.with? 'graphicsmagick'
    args << "-DWITH_EIGEN=true -DWITH_GMP=true -DWITH_CGAL=true" if build.with? 'cgal'

    mkdir 'build' do
      system "cmake", "..", *args
      system "make"
      system "make install"
    end
  end
end

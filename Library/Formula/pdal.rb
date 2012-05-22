require 'formula'

class Pdal < Formula
  homepage 'http://pointcloud.org'
  url 'https://github.com/PDAL/PDAL/zipball/0.6.0'
  md5 'e21c2227a9302f033f8ecf513baedf51'

  def options
  [
    ['--embed-boost', 'Use embedded Boost?'],
#    ['--with-gdal', 'Use GDAL?'],
#    ['--with-geotiff', 'Use GeoTIFF?'],
    ['--with-iconv', 'Use ICONV?'],
    ['--with-laszip', 'Use LASZIP?'],
    ['--with-libxml2', 'Use libXML2?'],
    ['--with-mrsid', 'Use MRSID?'],
    ['--with-oracle', 'Use Oracle?'],
    ['--with-p2g', 'Use P2G?'],
    ['--with-pkgconfig', 'Use PkgConfig?'],
    ['--with-python', 'Use Python?'],
    ['--with-swig-csharp', 'Use SWIG C#?'],
    ['--with-swig-python', 'Use SWIG Python?'],
    ['--with-tests', 'Use tests?']
  ]
  end

  depends_on 'cmake' => :build
  depends_on 'boost' unless ARGV.include? '--embed-boost'

#  depends_on 'libgeotiff' if ARGV.include? '--with-geotiff' || '--with-gdal'
#  depends_on 'gdal' if ARGV.include? '--with-gdal'
  depends_on 'iconv' if ARGV.include? '--with-iconv'
  depends_on 'laszip' if ARGV.include? '--with-laszip'
  depends_on 'libxml2' if ARGV.include? '--with-libxml2'
  depends_on 'mrsid' if ARGV.include? '--with-mrsid'
  depends_on 'oracle' if ARGV.include? '--with-oracle'
  depends_on 'p2k' if ARGV.include? '--with-p2g'
  depends_on 'pkgconfig' if ARGV.include? '--with-pkgconfig'
  depends_on 'python' if ARGV.include? '--with-python'
  depends_on 'swig' if ARGV.include? '--with-swig-csharp' || '--with-swig-python'

  def install
    args = std_cmake_parameters.split

    if ARGV.include? '--with-gdal'
      args << "-DWITH_GDAL:BOOL=ON"
    end

    if ARGV.include? '--with-geotiff'
      args << "-DWITH_GEOTIFF:BOOL=ON"
    end

    if ARGV.include? '--with-iconv'
      args << "-DWITH_ICONV:BOOL=ON"
    end

    if ARGV.include? '--with-laszip'
      args << "-DWITH_LASZIP:BOOL=ON"
    end

    if ARGV.include? '--with-libxml2'
      args << "-DWITH_LIBXML2:BOOL=ON"
    end

    if ARGV.include? '--with-mrsid'
      args << "-DWITH_MRSID:BOOL=ON"
    end

    if ARGV.include? '--with-oracle'
      args << "-DWITH_ORACLE:BOOL=ON"
    end

    if ARGV.include? '--with-p2g'
      args << "-DWITH_P2G:BOOL=ON"
    end

    if ARGV.include? '--with-pkgconfig'
      args << "-DWITH_PKGCONFIG:BOOL=ON"
    end

    if ARGV.include? '--with-python'
      args << "-DWITH_PYTHON:BOOL=ON"
    end

    if ARGV.include? '--with-swig-csharp'
      args << "-DWITH_SWIG_CSHARP:BOOL=ON"
    end

    if ARGV.include? '--with-swig-python'
      args << "-DWITH_SWIG_PYTHON:BOOL=ON"
    end

    if ARGV.include? '--with-tests'
      args << "-DWITH_TESTS:BOOL=ON"
    end

    args << ".."

    mkdir 'build' do
      ENV['Boost_INCLUDE_DIR'] = "#{HOMEBREW_PREFIX}/include"
      ENV['Boost_LIBRARYS_DIRS'] = "#{HOMEBREW_PREFIX}/lib"
      system "cmake", *args
      system "make install"
    end
  end

  def caveats
    <<-EOS
There is currently a bug when attempting to build with the latest
release versions of GDAL and libgeotiff. If this functionality is
required, it is best to build from trunk of the respective SVN
repositories.
   EOS
  end
end

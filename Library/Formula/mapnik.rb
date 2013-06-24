require 'formula'

class Mapnik < Formula
  homepage 'http://www.mapnik.org/'
  url 'http://mapnik.s3.amazonaws.com/dist/v2.2.0/mapnik-v2.2.0.tar.bz2'
  sha1 'e493ad87ca83471374a3b080f760df4b25f7060d'

  head 'https://github.com/mapnik/mapnik.git'

  depends_on 'pkg-config' => :build
  depends_on :python
  depends_on :freetype
  depends_on :libpng
  depends_on 'libtiff'
  depends_on 'proj'
  depends_on 'icu4c'
  depends_on 'jpeg'
  depends_on 'boost'
  depends_on 'gdal' => :optional
  depends_on 'postgresql' => :optional
  depends_on 'geos' => :optional
  depends_on 'cairo' => :optional

  depends_on 'py2cairo' if build.with? 'cairo'

  def install
    icu = Formula.factory("icu4c").opt_prefix
    boost = Formula.factory('boost').opt_prefix
    proj = Formula.factory('proj').opt_prefix
    jpeg = Formula.factory('jpeg').opt_prefix
    libtiff = Formula.factory('libtiff').opt_prefix

    # mapnik compiles can take ~1.5 GB per job for some .cpp files
    # so lets be cautious by limiting to CPUS/2
    jobs = ENV.make_jobs.to_i
    jobs /= 2 if jobs > 2

    args = [ "CC=\"#{ENV.cc}\"",
             "CXX=\"#{ENV.cxx}\"",
             "JOBS=#{jobs}",
             "PREFIX=#{prefix}",
             "ICU_INCLUDES=#{icu}/include",
             "ICU_LIBS=#{icu}/lib",
             "PYTHON_PREFIX=#{prefix}",  # Install to Homebrew's site-packages
             "JPEG_INCLUDES=#{jpeg}/include",
             "JPEG_LIBS=#{jpeg}/lib",
             "TIFF_INCLUDES=#{libtiff}/include",
             "TIFF_LIBS=#{libtiff}/lib",
             "BOOST_INCLUDES=#{boost}/include",
             "BOOST_LIBS=#{boost}/lib",
             "PROJ_INCLUDES=#{proj}/include",
             "PROJ_LIBS=#{proj}/lib" ]

    if build.with? 'cairo'
      args << "CAIRO=True" # cairo paths will come from pkg-config
    else
      args << "CAIRO=False"
    end
    args << "GEOS_CONFIG=#{Formula.factory('geos').opt_prefix}/bin/geos-config" if build.with? 'geos'
    args << "GDAL_CONFIG=#{Formula.factory('gdal').opt_prefix}/bin/gdal-config" if build.with? 'gdal'
    args << "PG_CONFIG=#{Formula.factory('postgresql').opt_prefix}/bin/pg_config" if build.with? 'postgresql'

    python do
      system python, "scons/scons.py", "configure", *args
      system python, "scons/scons.py", "install"
    end
  end

  def caveats
    python.standard_caveats if python
  end
end

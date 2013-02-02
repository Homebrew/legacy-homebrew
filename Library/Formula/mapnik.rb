require 'formula'

class Mapnik < Formula
  homepage 'http://www.mapnik.org/'
  url 'https://github.com/downloads/mapnik/mapnik/mapnik-v2.1.0.tar.bz2'
  sha1 'b1c6a138e65a5e20f0f312a559e2ae7185adf5b6'

  head 'https://github.com/mapnik/mapnik.git'

  option 'with-cairo', 'Build with Cairo'
  option 'with-gdal', 'Build with optional "Geospatial Data Abstraction Library"'
  option 'with-geos', 'Build with the GEOS (Geometry Engine)'

  depends_on :libtool
  depends_on :freetype
  depends_on :libpng
  depends_on 'libtiff'
  depends_on 'proj'
  depends_on 'icu4c'
  depends_on 'jpeg'
  depends_on 'boost'
  depends_on 'gdal' if build.include? 'with-gdal'
  depends_on 'geos' if build.include? 'with-geos'
  depends_on 'pkg-config' => :build

  if build.include? 'with-cairo'
    depends_on 'cairo' => :optional
    depends_on 'py2cairo'
    depends_on 'cairomm' => :optional
  end

  def install
    icu = Formula.factory("icu4c").opt_prefix
    boost = Formula.factory('boost').opt_prefix
    proj = Formula.factory('proj').opt_prefix
    jpeg = Formula.factory('jpeg').opt_prefix
    libtiff = Formula.factory('libtiff').opt_prefix
    cairo = Formula.factory('cairo').opt_prefix if build.include? 'cairo'
    # mapnik compiles can take ~1.5 GB per job for some .cpp files
    # so lets be cautious by limiting to CPUS/2
    jobs = ENV.make_jobs
    if jobs > 2
        jobs = Integer(jobs/2)
    end

    args = [ "scons/scons.py",
             "configure",
             "CC=\"#{ENV.cc}\"",
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

    if build.include? 'cairo'
      args << "CAIRO_INCLUDES=#{cairo}/include"
      args << "CAIRO_LIBS=#{cairo}/lib"
    end
    args << "GEOS_CONFIG=#{Formula.factory('geos').opt_prefix}/bin/geos-config" if build.include? 'with-geos'
    args << "GDAL_CONFIG=#{Formula.factory('gdal').opt_prefix}/bin/gdal-config" if build.include? 'with-gdal'

    system "python", *args

    system "python",
           "scons/scons.py",
           "install"
  end

  def caveats; <<-EOS.undent
    For non-homebrew Python, you need to amend your PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH
    EOS
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end

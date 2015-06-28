class Openvdb < Formula
  desc "Sparse volume processing toolkit"
  homepage "http://www.openvdb.org/"
  url "https://github.com/dreamworksanimation/openvdb/archive/v3.0.0.tar.gz"
  sha256 "6c90cfda032c54876b321031717c13ea56a6b7b15c911d3edfbb2ad7af49700e"
  head "https://github.com/dreamworksanimation/openvdb.git"

  bottle do
    sha256 "843a6b55c84185101c1e1b379751e99cd0215f2fce7534ef3a2387a33a7c91a5" => :yosemite
  end

  option 'tests', 'Installs and runs the unit tests for the OpenVDB library'
  option 'logging', 'Requires log4cplus'
  option 'docs', 'Installs documentation'

  depends_on "boost"
  depends_on "openexr"
  depends_on "ilmbase"
  depends_on "tbb"
  depends_on "jemalloc" => :recommended
  depends_on "homebrew/versions/glfw3" => :recommended

  if build.with? "tests"
    depends_on "cppunit"
  end

  if build.with? "docs"
    depends_on "doxygen"
  end

  if build.with? "logging"
    depends_on "log4cplus"
  end

  resource "test_file" do
    url "http://www.openvdb.org/download/models/cube.vdb.zip"
    sha256 "05476e84e91c0214ad7593850e6e7c28f777aa4ff0a1d88d91168a7dd050f922"
  end

  def install
    # Adjust hard coded paths in Makefile
    inreplace "openvdb/Makefile", "/tmp/OpenVDB", "#{prefix}"
    inreplace "openvdb/Makefile", "BOOST_INCL_DIR := $(HT)/include", "BOOST_INCL_DIR:=#{Formula["boost"].opt_lib}/include"
    inreplace "openvdb/Makefile", "BOOST_LIB_DIR := $(HDSO)", "BOOST_LIB_DIR:=#{Formula["boost"].opt_lib}"
    inreplace "openvdb/Makefile", "TBB_INCL_DIR := $(HT)/include", "TBB_INCL_DIR:=#{Formula["tbb"].opt_lib}/include"
    inreplace "openvdb/Makefile", "TBB_LIB_DIR := $(HDSO)", "TBB_LIB_DIR:=#{Formula["tbb"].opt_lib}/lib"
    inreplace "openvdb/Makefile", "EXR_INCL_DIR := $(HT)/include", "EXR_INCL_DIR:=#{Formula["openexr"].opt_lib}/include"
    inreplace "openvdb/Makefile", "EXR_LIB_DIR := $(HDSO)", "EXR_LIB_DIR:=#{Formula["openexr"].opt_lib}/lib"
    inreplace "openvdb/Makefile", "-lboost_thread", "-lboost_thread-mt"

    inreplace "openvdb/Makefile", "PYTHON_VERSION := 2.6", "PYTHON_VERSION :="
    inreplace "openvdb/Makefile", "NUMPY_INCL_DIR := /rel/map/generic-2013.22/include", "NUMPY_INCL_DIR :="

  if build.with? "jemalloc"
    inreplace "openvdb/Makefile", "CONCURRENT_MALLOC_LIB_DIR := $(HDSO)", "CONCURRENT_MALLOC_LIB_DIR:=#{Formula["jemalloc"].opt_lib}/lib"
  else
    inreplace "openvdb/Makefile", "-ljemalloc", ""
  end

  if build.with? "glfw3"
    inreplace "openvdb/Makefile", "-lglfw", "-lglfw3"
  else
    inreplace "openvdb/Makefile", "-lglfw", ""
  end

  if build.without? "doxygen"
  inreplace "openvdb/Makefile", "DOXYGEN := doxygen", "DOXYGEN :="
  end

  if build.with? "cppunit"
    inreplace "openvdb/Makefile", "CPPUNIT_INCL_DIR := /rel/map/generic-2013.22/sys_include", "CPPUNIT_INCL_DIR:=#{Formula["cppunit"].opt_lib}/include"
    inreplace "openvdb/Makefile", "CPPUNIT_LIB_DIR := /rel/depot/third_party_build/cppunit/1.10.2-7/opt-ws5-x86_64-gccWS5_64/lib", "CPPUNIT_LIB_DIR:=#{Formula["cppunit"].opt_lib}/lib"
  else
    inreplace "openvdb/Makefile", "CPPUNIT_INCL_DIR := /rel/map/generic-2013.22/sys_include", ""
  end

  if build.with? "log4cplus"
    inreplace "openvdb/Makefile", "LOG4CPLUS_INCL_DIR := /rel/folio/log4cplus/log4cplus-1.0.3-latest/sys_include", "LOG4CPLUS_INCL_DIR:=#{Formula["log4cplus"].opt_lib}/include"
    inreplace "openvdb/Makefile", "LOG4CPLUS_LIB_DIR := /rel/folio/log4cplus/log4cplus-1.0.3-latest/library", "LOG4CPLUS_LIB_DIR:=#{Formula["log4cplus"].opt_lib}/lib"
  else
    inreplace "openvdb/Makefile", "LOG4CPLUS_INCL_DIR := /rel/folio/log4cplus/log4cplus-1.0.3-latest/sys_include", "LOG4CPLUS_INCL_DIR:="
  end

  # Blosc is not yet supported.
  inreplace "openvdb/Makefile", "BLOSC_INCL_DIR := $(HT)/include", "BLOSC_INCL_DIR :="

  ENV.append_to_cflags "-std=c++11"

  ENV.append_to_cflags "-I #{buildpath}"

  cd "openvdb"
  system "make", "install"

  end

  test do
    resource("test_file").stage testpath
    system "#{bin}/vdb_print", "-m", "cube.vdb"
  end
end

class Openvdb < Formula
  desc "Sparse volume processing toolkit"
  homepage "http://www.openvdb.org/"
  url "https://github.com/dreamworksanimation/openvdb/archive/v3.0.0.tar.gz"
  sha256 "6c90cfda032c54876b321031717c13ea56a6b7b15c911d3edfbb2ad7af49700e"
  head "https://github.com/dreamworksanimation/openvdb.git"

  option "with-viewer", "Installs the command-line tool to view OpenVDB files"
  option "with-tests", "Installs the unit tests for the OpenVDB library"
  option "with-logging", "Requires log4cplus"
  option "with-docs", "Installs documentation"

  depends_on "boost"
  depends_on "openexr"
  depends_on "ilmbase"
  depends_on "tbb"
  depends_on "jemalloc" => :recommended

  depends_on "homebrew/versions/glfw3" if build.with? "viewer"
  depends_on "cppunit" if build.with? "tests"
  depends_on "doxygen" if build.with? "docs"
  depends_on "log4cplus" if build.with? "logging"
  needs :cxx11

  resource "test_file" do
    url "http://www.openvdb.org/download/models/cube.vdb.zip"
    sha256 "05476e84e91c0214ad7593850e6e7c28f777aa4ff0a1d88d91168a7dd050f922"
  end

  def install
    ENV.cxx11
    # Adjust hard coded paths in Makefile
    if build.with? "jemalloc"
      jemalloc = "CONCURRENT_MALLOC_LIB_DIR=#{Formula["jemalloc"].opt_lib}/lib"
    else
      jemalloc = "CONCURRENT_MALLOC_LIB="
    end

    if build.with? "viewer"
      glfw3 = "GLFW_INCL_DIR=#{Formula["homebrew/versions/glfw3"].opt_lib}/include"
      glfw3_lib = "GLFW_LIB_DIR=#{Formula["homebrew/versions/glfw3"].opt_lib}/lib"
      glfw3_libname =  "GLFW_LIB=-lglfw3"
    else
      glfw3 =  "GLFW_INCL_DIR="
      glfw3_lib = "GLFW_LIB_DIR="
      glfw3_libname = "GLFW_LIB="
    end

    if build.with? "docs"
      doxygen = "DOXYGEN=doxygen"
    else
      doxygen = "DOXYGEN="
    end

    if build.with? "tests"
      cppunit = "CPPUNIT_INCL_DIR=#{Formula["cppunit"].opt_lib}/include"
      cppunit_lib =  "CPPUNIT_LIB_DIR=#{Formula["cppunit"].opt_lib}/lib"
    else
      cppunit = "CPPUNIT_INCL_DIR="
      cppunit_lib =  "CPPUNIT_LIB_DIR="
    end

    if build.with? "logging"
      log4cplus = "LOG4CPLUS_INCL_DIR=#{Formula["log4cplus"].opt_lib}/include"
      log4cplus_lib =  "LOG4CPLUS_LIB_DIR=#{Formula["log4cplus"].opt_lib}/lib"
    else
      log4cplus = "LOG4CPLUS_INCL_DIR="
      log4cplus_lib =  "LOG4CPLUS_LIB_DIR="
    end

    ENV.append_to_cflags "-I #{buildpath}"

    cd "openvdb" do
      system "make", "install", "DESTDIR=#{prefix}",
                              "BOOST_INCL_DIR=#{Formula["boost"].opt_lib}/include",
                              "BOOST_LIB_DIR=#{Formula["boost"].opt_lib}",
                              "BOOST_THREAD_LIB=-lboost_thread-mt",
                              "TBB_INCL_DIR=#{Formula["tbb"].opt_lib}/include",
                              "TBB_LIB_DIR=#{Formula["tbb"].opt_lib}/lib",
                              "EXR_INCL_DIR=#{Formula["openexr"].opt_lib}/include",
                              "EXR_LIB_DIR=#{Formula["openexr"].opt_lib}/lib",
                              "BLOSC_INCL_DIR=", # Blosc is not yet supported.
                              "PYTHON_VERSION=",
                              "NUMPY_INCL_DIR=",
                              *jemalloc,
                              *glfw3,
                              *glfw3_lib,
                              *glfw3_libname,
                              *doxygen,
                              *cppunit,
                              *cppunit_lib,
                              *log4cplus,
                              *log4cplus_lib
    end
  end

  test do
    resource("test_file").stage testpath
    system "#{bin}/vdb_print", "-m", "cube.vdb"
  end
end

require "formula"

class Bob < Formula
  homepage "http://www.idiap.ch/software/bob/docs/releases/last/sphinx/html/index.html"
  url "http://www.idiap.ch/software/bob/packages/bob-1.2.2.tar.gz"
  sha1 "c557712996ae8a6a1e161026f539d1f1fd108fb0"


  depends_on "blitz"
  depends_on "lapack"
  depends_on "boost"
  depends_on "fftw"
  depends_on "jpeg"
  depends_on "netpbm"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "giflib"
  depends_on "hdf5"
  depends_on "ffmpeg"
  depends_on "libmatio"
  depends_on "qt"

  depends_on :python
  depends_on "numpy" => :python
  depends_on "scipy" => :python
  depends_on "matplotlib" => :python
  depends_on "sqlalchemy" => :python
  depends_on "argparse" => :python
  depends_on "nose" => :python
  depends_on "setuptools" => :python

  depends_on "cmake" => :build
  depends_on 'pkg-config' => :build



  def install
    # Usual cmake arguments
    args = *std_cmake_args + ["-DWITH_VLFEAT=OFF"]

    mkdir "build" do

      # The CMake `FindPythonLibs` Module does not do a good job of finding the
      # correct Python libraries to link to, so we help it out (until CMake is
      # fixed). This code was cribbed from the opencv formula, which took it from
      # the VTK formula. It uses the output from `python-config`.
      which_python = "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
      python_prefix = `python-config --prefix`.strip
      # Python is actually a library. The libpythonX.Y.dylib points to this lib, too.
      if File.exist? "#{python_prefix}/Python"
        # Python was compiled with --framework:
        args << "-DPYTHON_LIBRARY='#{python_prefix}/Python'"
        args << "-DPYTHON_INCLUDE_DIR='#{python_prefix}/Headers'"
      else
        python_lib = "#{python_prefix}/lib/lib#{which_python}"
        if File.exists? "#{python_lib}.a"
          args << "-DPYTHON_LIBRARY='#{python_lib}.a'"
        else
          args << "-DPYTHON_LIBRARY='#{python_lib}.dylib'"
        end
        args << "-DPYTHON_INCLUDE_DIR='#{python_prefix}/include/#{which_python}'"
      end
      args << "-DPYTHON_PACKAGES_PATH='#{lib}/#{which_python}/site-packages'"

      system "cmake", "..", *args
      system "make"
      system "make test"
      system "make install"
    end
  end

  test do

    system "python", "-c", "import bob; print bob.version"

    TEST_PATH = "#{HOMEBREW_PREFIX}/lib/python2.7/site-packages/bob/trainer/test/"
    system "nosetests", *TEST_PATH + "test_backprop.py"
    system "nosetests", *TEST_PATH + "test_bic.py"
    system "nosetests", *TEST_PATH + "test_cglogreg.py"
    system "nosetests", *TEST_PATH + "test_cost.py"
    system "nosetests", *TEST_PATH + "test_em.py"
    system "nosetests", *TEST_PATH + "test_ivector.py"
    system "nosetests", *TEST_PATH + "test_jfa.py"
    system "nosetests", *TEST_PATH + "test_kmeans.py"
    system "nosetests", *TEST_PATH + "test_linear.py"
    system "nosetests", *TEST_PATH + "test_mlpbasetrainer.py"
    system "nosetests", *TEST_PATH + "test_rprop.py"
    system "nosetests", *TEST_PATH + "test_shuffler.py"
    system "nosetests", *TEST_PATH + "test_svm.py"
    system "nosetests", *TEST_PATH + "test_wiener.py"

  end
end

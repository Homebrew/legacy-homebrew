require 'formula'

class Bob < Formula
  homepage 'http://www.idiap.ch/software/bob/docs/releases/last/sphinx/html/index.html'
  url 'http://www.idiap.ch/software/bob/packages/bob-1.2.2.tar.gz'
  sha1 'c557712996ae8a6a1e161026f539d1f1fd108fb0'

  depends_on 'blitz'
  depends_on 'lapack'
  depends_on 'boost'
  depends_on 'fftw'
  depends_on 'jpeg'
  depends_on 'netpbm'
  depends_on 'libpng'
  depends_on 'libsvm'
  depends_on 'libtiff'
  depends_on 'giflib'
  depends_on 'hdf5'
  depends_on 'ffmpeg'
  depends_on 'libmatio'
  depends_on 'qt'
  depends_on :python

  resource 'numpy' do
    url 'http://downloads.sourceforge.net/project/numpy/NumPy/1.8.0/numpy-1.8.0.tar.gz'
    sha1 'a2c02c5fb2ab8cf630982cddc6821e74f5769974'
  end

  resource 'numpy' do
    url 'http://downloads.sourceforge.net/project/scipy/scipy/0.13.0/scipy-0.13.0.tar.gz'
    sha1 '704c2d0a855dd94a341546a475362038a9664dac'
  end

  resource 'matplotlib' do
    url 'https://downloads.sourceforge.net/project/matplotlib/matplotlib/matplotlib-1.3.1/matplotlib-1.3.1.tar.gz'
    sha1 '8578afc86424392591c0ee03f7613ffa9b6f68ee'
  end

  resource 'sqlalchemy' do
    url 'https://pypi.python.org/packages/source/S/SQLAlchemy/SQLAlchemy-0.9.1.tar.gz'
    sha1 '9270483fd82fe3de4add20e2b7b7548168d03a2b'
  end

  resource 'argparse' do
    url 'http://argparse.googlecode.com/files/argparse-1.2.1.tar.gz'
    sha1 'caadac82aa2576d6b445058c1fcf6ef0b14dbaa1'
  end

  resource 'nose' do
    url 'https://pypi.python.org/packages/source/n/nose/nose-1.3.0.tar.gz'
    sha1 'bd1bb889e421948ca57595e9e8d52246cb308294'
  end

  resource 'setuptools' do
    url 'https://pypi.python.org/packages/source/s/setuptools/setuptools-2.1.tar.gz'
    sha1 '3e4a325d807eb0104e98985e7bd9f1ef86fc2efa'
  end

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build

  def install

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
      system "make", "test"
      system "make", "install"
    end
  end

  test do
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


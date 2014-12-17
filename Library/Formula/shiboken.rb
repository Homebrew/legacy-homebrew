require 'formula'

class Shiboken < Formula
  homepage 'http://www.pyside.org/docs/shiboken'
  url 'http://download.qt-project.org/official_releases/pyside/shiboken-1.2.2.tar.bz2'
  mirror 'https://distfiles.macports.org/py-shiboken/shiboken-1.2.2.tar.bz2'
  sha1 '55731616791500750ef373f382057a43e133fa08'

  head 'git://gitorious.org/pyside/shiboken.git'

  bottle do
    revision 2
    sha1 "779be49a555b110c4156232528afe6e9cdd5d670" => :yosemite
    sha1 "e67d83ea94b343541df1b21cd793057fee325780" => :mavericks
    sha1 "81ea5e997e9910a54cf35e4b5827ab7b502836b3" => :mountain_lion
  end

  depends_on 'cmake' => :build
  depends_on 'qt'

  # don't use depends_on :python because then bottles install Homebrew's python
  option "without-python", "Build without python 2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  depends_on :python3 => :optional

  def install
    # As of 1.1.1 the install fails unless you do an out of tree build and put
    # the source dir last in the args.
    Language::Python.each_python(build) do |python, version|
      mkdir "macbuild#{version}" do
        args = std_cmake_args
        # Building the tests also runs them.
        args << "-DBUILD_TESTS=ON"
        if python == "python3" && Formula["python3"].installed?
          python_framework = (Formula["python3"].opt_prefix)/"Frameworks/Python.framework/Versions/#{version}"
          args << "-DPYTHON3_INCLUDE_DIR:PATH=#{python_framework}/Headers"
          args << "-DPYTHON3_LIBRARY:FILEPATH=#{python_framework}/lib/libpython#{version}.dylib"
        end
        args << "-DUSE_PYTHON3:BOOL=ON" if python == "python3"
        args << ".."
        system "cmake", *args
        system "make", "install"
      end
    end
  end

  test do
    Language::Python.each_python(build) do |python, version|
      system python, "-c", "import shiboken"
    end
  end
end

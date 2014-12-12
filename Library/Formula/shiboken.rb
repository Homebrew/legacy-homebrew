require 'formula'

class Shiboken < Formula
  homepage 'http://www.pyside.org/docs/shiboken'
  url 'http://download.qt-project.org/official_releases/pyside/shiboken-1.2.2.tar.bz2'
  mirror 'https://distfiles.macports.org/py-shiboken/shiboken-1.2.2.tar.bz2'
  sha1 '55731616791500750ef373f382057a43e133fa08'

  head 'git://gitorious.org/pyside/shiboken.git'

  bottle do
    revision 1
    sha1 "9dd0d0026901e52cf489bd715f0e297bd53d5ce3" => :yosemite
    sha1 "2b6b704bc0b7dbd0ab666275f0fd415dfe5590ad" => :mavericks
    sha1 "082137538998bde0e874011670a65a497c9157bf" => :mountain_lion
  end

  depends_on 'cmake' => :build
  depends_on 'qt'

  depends_on :python => :recommended
  depends_on :python3 => :optional

  def install
    # As of 1.1.1 the install fails unless you do an out of tree build and put
    # the source dir last in the args.
    Language::Python.each_python(build) do |python, version|
      mkdir "macbuild#{version}" do
        args = std_cmake_args
        # Building the tests also runs them.
        args << "-DBUILD_TESTS=ON"
        # if not System Python
        python_framework = "#{Formula[python].opt_prefix}/Frameworks/Python.framework/Versions/#{version}"
        if version.to_s[0,1] == "2" && Formula["python"].installed?
          args << "-DPYTHON_INCLUDE_DIR:PATH=#{python_framework}/Headers"
          args << "-DPYTHON_LIBRARY:FILEPATH=#{python_framework}/lib/libpython#{version}.dylib"
        elsif version.to_s[0,1] == "3" && Formula["python3"].installed?
          args << "-DPYTHON3_INCLUDE_DIR:PATH=#{python_framework}/Headers"
          args << "-DPYTHON3_LIBRARY:FILEPATH=#{python_framework}/lib/libpython#{version}.dylib"
          args << "-DUSE_PYTHON3:BOOL=ON"
        end
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

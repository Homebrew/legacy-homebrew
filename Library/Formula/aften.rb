require 'formula'

class Aften < Formula
  url 'http://downloads.sourceforge.net/aften/aften-0.0.8.tar.bz2'
  head 'git://aften.git.sourceforge.net/gitroot/aften/aften'
  homepage 'http://aften.sourceforge.net/'
  md5 'fde67146879febb81af3d95a62df8840'

  depends_on 'cmake' => :build

  def options
    [[ '--with-cxx', 'Enable C++ bindings (lightly tested)' ]]
  end

  def install
    Dir.mkdir 'default'
    Dir.chdir 'default'
    args = std_cmake_parameters.split + [ "-DSHARED=ON" ]
    args << "-DBINDINGS_CXX=ON" if ARGV.include? "--with-cxx"
    args << ".."
    system "cmake", *args
    system "make"
    system "make install"
  end
end

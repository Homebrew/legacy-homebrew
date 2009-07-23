require 'brewkit'

class Cmake <Formula
  @url='http://www.cmake.org/files/v2.6/cmake-2.6.3.tar.gz'
  @md5='5ba47a94ce276f326abca1fd72a7e7c6'
  @homepage='http://www.cmake.org/'

  def deps
    LibraryDep.new 'xmlrpc', 'xmlrpc-c'
  end

  def install
    system "./bootstrap --prefix=#{prefix} --system-libs --datadir=/share/cmake --docdir=/share/cmake --mandir=/share/man"
    system "make install"

    # txt sucks, welcome to 1990
    Dir["#{prefix}/share/cmake/*.txt"].each {|f| File.unlink f}
  end
end
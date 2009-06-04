require 'brewkit'

class Cmake <Formula
  @url='http://www.cmake.org/files/v2.6/cmake-2.6.3.tar.gz'
  @md5='5ba47a94ce276f326abca1fd72a7e7c6'

  def install
    system "./bootstrap --prefix=#{prefix} --system-libs"
    system "make install"

    ['man','doc'].each { |d| (prefix+d).mv prefix+'share' }
  end
end
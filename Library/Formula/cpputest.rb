require 'formula'

class Cpputest < Formula
  homepage 'http://www.cpputest.org/'
  url 'http://downloads.sourceforge.net/project/cpputest/cpputest/v2.3/CppUTest-v2.3.zip'
  sha1 '0abd7abfbafdeaffcff6083fd8c3e20408bd0d5a'

  def install
    system "make"
    lib.install 'lib/libCppUTest.a'
    include.install 'include/CppUTest'
  end
end

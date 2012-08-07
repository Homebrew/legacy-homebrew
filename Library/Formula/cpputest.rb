require 'formula'

class Cpputest < Formula
  homepage 'http://www.cpputest.org/'
  url 'http://sourceforge.net/projects/cpputest/files/cpputest/v3.1/CppUTest-v3.1.zip'
  sha1 '8ff6b764a9ca6202582ae0c94545f56b921f39d5'

  fails_with :clang do
    build 412
  end

  def install
    system "make"
    lib.install 'lib/libCppUTest.a'
    include.install 'include/CppUTest'
  end
end

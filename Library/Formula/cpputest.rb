require 'formula'

class Cpputest < Formula
  homepage 'http://www.cpputest.org/'
  url 'http://downloads.sourceforge.net/project/cpputest/cpputest/v2.3/CppUTest-v2.3.zip'
  md5 '0546bf6d0f1513842cfa781255dcbdda'

  def install
    system "make"
    lib.install 'lib/libCppUTest.a'
    include.install 'include/CppUTest'
  end
end

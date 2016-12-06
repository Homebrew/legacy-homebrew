require 'formula'

class Cpputest < Formula
  url 'http://downloads.sourceforge.net/project/cpputest/cpputest/v2.3/CppUTest-v2.3.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fcpputest%2Ffiles%2Fcpputest%2Fv2.3%2F&ts=1310228588&use_mirror=voxel'
  homepage 'http://www.cpputest.org/'
  md5 '0546bf6d0f1513842cfa781255dcbdda'
  version '2.3'

  def install
    system "make"
    lib.install ['lib/libCppUTest.a']
    include.install ['include/CppUTest']
  end
end

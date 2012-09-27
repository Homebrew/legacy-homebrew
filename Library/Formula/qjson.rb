require 'formula'

class Qjson < Formula
  homepage 'http://qjson.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/qjson/qjson/0.7.1/qjson-0.7.1.tar.bz2'
  sha1 '19bbef24132b238e99744bb35194c6dadece98f9'

  depends_on 'cmake' => :build
  depends_on 'qt'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end

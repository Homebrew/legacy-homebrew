require 'formula'

class Qjson < Formula
  homepage 'http://qjson.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/qjson/qjson/0.7.1/qjson-0.7.1.tar.bz2'
  md5 '5a833ad606c164ed8aa69f0873366ace'

  depends_on 'cmake' => :build
  depends_on 'qt'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end

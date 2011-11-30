require 'formula'

class Shark < Formula
  url 'http://downloads.sourceforge.net/project/shark-project/Shark%20Core/Shark%202.3.4/shark-2.3.4.zip'
  homepage 'http://shark-project.sourceforge.net/'
  md5 '12d87a519c27b33800df11b7c78972ed'

  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end

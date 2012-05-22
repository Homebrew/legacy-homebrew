require 'formula'

class Shark < Formula
  homepage 'http://shark-project.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/shark-project/Shark%20Core/Shark%202.3.4/shark-2.3.4.zip'
  md5 '12d87a519c27b33800df11b7c78972ed'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end

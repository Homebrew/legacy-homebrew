require 'formula'

class Tinyxml2 < Formula
  homepage 'http://www.grinninglizard.com/tinyxml2/index.html'
  head 'https://github.com/leethomason/tinyxml2.git'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end

require 'formula'

# Documentation: http://openbiometrics.org/doxygen/latest/index.html

class Openbr < Formula
  homepage 'http://openbiometrics.org/'
  url 'http://www.cse.msu.edu/~klumscot/openbr-0.3.zip'
  sha1 '95cb8db8e22d86488eec4f813697fa8fc96ea80f'

  depends_on 'homebrew/science/opencv' => '--env=std'
  depends_on 'qt5'
  depends_on 'cmake' => :build

  def install
    system "mkdir", "build"
    cd 'build' do
       system "cmake", "..", *std_cmake_args
       system "make"
       system "make install"
    end
  end
end

require 'formula'

class Libmini < Formula
  homepage 'http://code.google.com/p/libmini/'
  url 'http://libmini.googlecode.com/files/MINI-10.8.zip'
  sha1 'ef3516c455c2765c8342c712aa3d89c7960873db'

  depends_on 'cmake' => :build
  
  option 'examples',  'Compile and install examples'
  option 'shared', 'Build shared libs'

  def install
    args = std_cmake_args

    args << '-DBUILD_MINI_EXAMPLE=' + ((build.include? 'examples') ? 'ON' : 'OFF')
    args << '-BUILD_SHARED_LIBS=' + ((build.include? 'shared') ? 'ON' : 'OFF')
    args << ".."

    mkdir 'build' do
      system 'cmake', *args
      system 'make'
      system 'make install'
    end
  end
end

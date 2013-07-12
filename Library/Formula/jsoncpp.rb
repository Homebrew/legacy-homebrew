require 'formula'

class Jsoncpp < Formula
  homepage 'http://sourceforge.net/projects/jsoncpp/'
  url 'svn://svn.code.sf.net/p/jsoncpp/code/trunk/jsoncpp', :revision => 'r268'

  version '0.6.0-rc2'

  depends_on 'cmake' => :build

  def install
    args = std_cmake_args + %W[
      -DBUILD_TESTING:BOOL=OFF
    ]
    args << ".."

    mkdir 'jsoncpp-build' do
      system "cmake", *args
      system "make install"
    end
  end
end

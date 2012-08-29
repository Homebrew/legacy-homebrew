require 'formula'

class Box2d < Formula
  homepage 'http://www.box2d.org/'
  url 'http://box2d.googlecode.com/files/Box2D_v2.2.1.zip'
  sha1 'f97e75227a19b01858b1431e5f3eb6b8827bed12'

  depends_on 'cmake' => :build

  def install
    cd 'Build' do
      system "cmake", "..",
                      "-DBOX2D_INSTALL=ON",
                      "-DBOX2D_BUILD_SHARED=ON",
                      *std_cmake_args
      system "make install"
    end
  end
end

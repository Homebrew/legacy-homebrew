require 'formula'

class Box2d < Formula
  url 'http://box2d.googlecode.com/files/Box2D_v2.2.1.zip'
  homepage 'http://www.box2d.org/'
  sha1 'f97e75227a19b01858b1431e5f3eb6b8827bed12'

  depends_on 'cmake' => :build

  def install
    # docs say build oos
    Dir.chdir 'Build' do
      system "cmake -DBOX2D_INSTALL=ON -DBOX2D_BUILD_SHARED=ON #{std_cmake_parameters} .."
      system "make install"
    end
  end
end

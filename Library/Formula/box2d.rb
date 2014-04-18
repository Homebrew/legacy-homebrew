require 'formula'

class Box2d < Formula
  homepage 'http://www.box2d.org/'
  url 'https://box2d.googlecode.com/files/Box2D_v2.3.0.7z'
  sha1 '1d3ea1f872b3cab3ef5130a2404d74f9ff66f265'

  depends_on 'cmake' => :build

  def install
    cd "Box2D_v#{version}/Box2D" do
      system "cmake", "-DBOX2D_INSTALL=ON",
                      "-DBOX2D_BUILD_SHARED=ON",
                      "-DBOX2D_BUILD_EXAMPLES=OFF",
                      *std_cmake_args
      system "make install"
    end
  end
end

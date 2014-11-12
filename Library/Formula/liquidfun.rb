require "formula"

class Liquidfun < Formula
  homepage "http://google.github.io/liquidfun/"
  url "https://github.com/google/liquidfun/releases/download/v1.1.0/liquidfun-1.1.0.zip"
  sha1 "ad1bca48f617805394ca61ec890f84d2133bcba3"

  depends_on "cmake" => :build

  conflicts_with "box2d", :because => "liquidfun is based on box2d and include it"

  def install
    cd "liquidfun" do
      cd "Box2D" do
        system "cmake", "-DBOX2D_INSTALL=ON",
                        "-DBOX2D_BUILD_SHARED=ON",
                        "-DBOX2D_BUILD_EXAMPLES=OFF",
                        *std_cmake_args
        system "make install"
        (include/"Box2D/Common").install "Box2D/Common/b2GrowableBuffer.h"
      end
    end
  end
end

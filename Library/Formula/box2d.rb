class Box2d < Formula
  desc "2D physics engine for games"
  homepage "http://www.box2d.org/"
  url "https://box2d.googlecode.com/files/Box2D_v2.3.0.7z"
  sha256 "2ebdb30863b7f5478e99b4425af210f8c32ef62faf1e0d2414c653072fff403d"

  depends_on "cmake" => :build

  def install
    cd "Box2D_v#{version}/Box2D" do
      system "cmake", "-DBOX2D_INSTALL=ON",
                      "-DBOX2D_BUILD_SHARED=ON",
                      "-DBOX2D_BUILD_EXAMPLES=OFF",
                      *std_cmake_args
      system "make", "install"
    end
  end
end

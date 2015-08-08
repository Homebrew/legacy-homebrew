class Box2d < Formula
  desc "2D physics engine for games"
  homepage "http://www.box2d.org/"
  url "https://github.com/erincatto/Box2D/archive/v2.3.1.tar.gz"
  sha256 "2c61505f03ef403b54cf0e510d83d6f567e37882ad79b5b2d486acbc7d5eedea"
  head "https://github.com/erincatto/Box2D.git"

  depends_on "cmake" => :build

  def install
    cd "Box2D" do
      system "cmake", "-DBOX2D_INSTALL=ON",
                      "-DBOX2D_BUILD_SHARED=ON",
                      "-DBOX2D_BUILD_EXAMPLES=OFF",
                      *std_cmake_args
      system "make", "install"
    end
    libexec.install "Box2D/HelloWorld"
  end

  test do
    system ENV.cxx, "-L#{lib}", "-lbox2d",
           libexec/"HelloWorld/HelloWorld.cpp", "-o", testpath/"test"
    system "./test"
  end
end

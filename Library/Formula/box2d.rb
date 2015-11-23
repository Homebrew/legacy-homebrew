class Box2d < Formula
  desc "2D physics engine for games"
  homepage "http://www.box2d.org/"
  url "https://github.com/erincatto/Box2D/archive/v2.3.1.tar.gz"
  sha256 "2c61505f03ef403b54cf0e510d83d6f567e37882ad79b5b2d486acbc7d5eedea"
  head "https://github.com/erincatto/Box2D.git"

  bottle do
    cellar :any
    sha256 "1559be0d79e66e8074a051f36db5bbf21a9d556013803cce7e04184bd28028a9" => :yosemite
    sha256 "40effd7d4952d37d15e7b34da4b9c207956b1d79bdd856f9f03307ecf52a5b3f" => :mavericks
    sha256 "143949e28a0b74432015b56f6372682ce69cfb451ccd82a3f4b1fb1c69e24310" => :mountain_lion
  end

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

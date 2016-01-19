class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https://libproxy.github.io/libproxy/"

  head "https://github.com/libproxy/libproxy.git"

  stable do
    url "https://github.com/libproxy/libproxy/archive/0.4.12.tar.gz"
    sha256 "add9c5e30767c17b00f842f6280d818ece1eb23ab92e1fc68661204c95d7e22b"
    # Fix compilation errors with CLang on MacOSX
    patch do
      url "https://github.com/libproxy/libproxy/commit/48a441652edfd73654f0c21e51cc96c69d5070c3.diff"
      sha256 "ac714f2cc010a5428556b4b66a42f4df043a6f42540269bba7da11a773f7529c"
    end
  end
  bottle do
    sha256 "edcea19bf07732eb6d5bac30e590b7873efabc1658a0442d08870ab6ae671b9d" => :el_capitan
    sha256 "4b4c5c12c05d6c4eb47d8c49e42517c10374b0bb1cef3fcdd3d3b5109eb4a4c1" => :yosemite
    sha256 "8c9f98bc758a346c76816c91d396987e6aa1b0e11ed404eefa2c27f1cbec82d3" => :mavericks
  end


  depends_on "cmake" => :build

  def install
    mkdir "build" do
      # The build tries to install to non-standard locations for Python bindings, hence avoid it..
      system "cmake", "..", "-DWITH_PYTHON=no", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/proxy", "127.0.0.1"
  end
end

class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https://libproxy.github.io/libproxy/"
  url "https://github.com/libproxy/libproxy/archive/0.4.12.tar.gz"
  sha256 "add9c5e30767c17b00f842f6280d818ece1eb23ab92e1fc68661204c95d7e22b"

  stable do
    # Fix compilation errors with CLang on MacOSX
    patch do
      url "https://github.com/libproxy/libproxy/commit/48a441652edfd73654f0c21e51cc96c69d5070c3.diff"
      sha256 "ac714f2cc010a5428556b4b66a42f4df043a6f42540269bba7da11a773f7529c"
    end
  end

  head "https://github.com/libproxy/libproxy.git"

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

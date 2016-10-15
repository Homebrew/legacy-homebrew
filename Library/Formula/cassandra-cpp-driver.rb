class CassandraCppDriver < Formula
  homepage "http://datastax.github.io/cpp-driver/"
  url "https://github.com/datastax/cpp-driver/archive/1.0.0.tar.gz"
  sha1 "087aa2cf00e3c6f0eb75bb0471b78d255ea94562"

  head "https://github.com/datastax/cpp-driver.git", :branch => "1.0"

  depends_on "cmake" => :build
  depends_on "libuv"

  def install
    mkdir "build" do
      args = std_cmake_args - %w{-DCMAKE_BUILD_TYPE=None}
      args << "-DCMAKE_INSTALL_LIBDIR=#{lib}"
      args << "-DCMAKE_BUILD_TYPE=Release"
      args << "-DCASS_BUILD_STATIC=ON"
      system "cmake", "..", *args 
      system "make", "install"
    end
  end
end

require "formula"

class RabbitmqC < Formula
  homepage "https://github.com/alanxz/rabbitmq-c"
  url "https://github.com/alanxz/rabbitmq-c/archive/v0.5.1.tar.gz"
  sha1 "3a2fad69f65ef3a733fbfd9320717d2aedec5aa2"

  head "https://github.com/alanxz/rabbitmq-c.git"

  option :universal
  option "without-tools", "Build without command-line tools"

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "rabbitmq" => :recommended
  depends_on "popt" if build.with? "tools"

  def install
    ENV.universal_binary if build.universal?
    args = std_cmake_args
    args << "-DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF -DBUILD_API_DOCS=OFF"

    args << "-DBUILD_TOOLS=ON" if build.with? "tools"
    args << "-DBUILD_TOOLS=OFF" if build.without? "tools"

    system "cmake", ".", *args
    system "make install"
  end
end

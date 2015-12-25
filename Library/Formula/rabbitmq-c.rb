class RabbitmqC < Formula
  desc "RabbitMQ C client"
  homepage "https://github.com/alanxz/rabbitmq-c"
  url "https://github.com/alanxz/rabbitmq-c/releases/download/v0.7.1/rabbitmq-c-0.7.1.tar.gz"
  sha256 "23df349a7d157543e756acc67e47b217843ecbdafaefe3e4974073bb99d8a26d"

  head "https://github.com/alanxz/rabbitmq-c.git"

  bottle do
    cellar :any
    sha256 "c8bdc217b3634f6624cf43e14dfef33d6d941f1023fbc13cb2cfbcafa6a615b2" => :yosemite
    sha256 "62b6fe1b7d5cd1a78ba23073d5bc2832e74dea4a17fd73a9f27511075d148b78" => :mavericks
    sha256 "7e2d438a71277b84b721290e0eb9628ea1dd1c8f17e97eb43dd04603116b2eaa" => :mountain_lion
  end

  option :universal
  option "without-tools", "Build without command-line tools"

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "popt" if build.with? "tools"
  depends_on "openssl"

  def install
    ENV.universal_binary if build.universal?
    args = std_cmake_args
    args << "-DBUILD_EXAMPLES=OFF"
    args << "-DBUILD_TESTS=OFF"
    args << "-DBUILD_API_DOCS=OFF"

    if build.with? "tools"
      args << "-DBUILD_TOOLS=ON"
    else
      args << "-DBUILD_TOOLS=OFF"
    end

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "amqp-get", "--help"
  end
end

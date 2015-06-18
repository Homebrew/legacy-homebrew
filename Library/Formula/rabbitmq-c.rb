class RabbitmqC < Formula
  desc "RabbitMQ C client"
  homepage "https://github.com/alanxz/rabbitmq-c"
  url "https://github.com/alanxz/rabbitmq-c/archive/v0.7.0.tar.gz"
  sha256 "b8b9a5cca871968de95538a87189f7321a3f86aca07ae8a81874e93d73cf9a4d"

  head "https://github.com/alanxz/rabbitmq-c.git"

  bottle do
    cellar :any
    sha1 "496b4ca88678eb149a7ab595d8910f108e02cedd" => :mavericks
    sha1 "3e571b8134ad11c1bf00fc809f6ddb75bfe7ca27" => :mountain_lion
    sha1 "13949d69b20f76376819bb811bb6fe9972ed4a39" => :lion
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

    args << if build.with? "tools"
              "-DBUILD_TOOLS=ON"
            else
              "-DBUILD_TOOLS=OFF"
            end

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "amqp-get", "--help"
  end
end

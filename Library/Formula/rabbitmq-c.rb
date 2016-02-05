class RabbitmqC < Formula
  desc "RabbitMQ C client"
  homepage "https://github.com/alanxz/rabbitmq-c"
  url "https://github.com/alanxz/rabbitmq-c/releases/download/v0.7.1/rabbitmq-c-0.7.1.tar.gz"
  sha256 "23df349a7d157543e756acc67e47b217843ecbdafaefe3e4974073bb99d8a26d"

  head "https://github.com/alanxz/rabbitmq-c.git"

  bottle do
    cellar :any
    sha256 "5a6f844aeb5433fdc3e406ba9d319ee3df227d3841ee79c1a44ac7d09be91e97" => :el_capitan
    sha256 "bae2a20f1cfbd87e773bede8a02c93d4045da92dd10e6c5b169491e8d657ee05" => :yosemite
    sha256 "9169b80d2df549456ec072b248609645a8dbc88a84d0bad5e36dcc470a72b7f0" => :mavericks
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

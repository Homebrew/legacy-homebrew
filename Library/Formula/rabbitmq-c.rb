require "formula"

class RabbitmqC < Formula
  homepage "https://github.com/alanxz/rabbitmq-c"
  url "https://github.com/alanxz/rabbitmq-c/archive/v0.5.2.tar.gz"
  sha1 "6c442aefbc4477ac0598c05361c767a75d6e1541"

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
  depends_on "rabbitmq" => :recommended
  depends_on "popt" if build.with? "tools"

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
end

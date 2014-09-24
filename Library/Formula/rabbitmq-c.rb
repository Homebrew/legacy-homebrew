require "formula"

class RabbitmqC < Formula
  homepage "https://github.com/alanxz/rabbitmq-c"
  url "https://github.com/alanxz/rabbitmq-c/archive/v0.5.2.tar.gz"
  sha1 "6c442aefbc4477ac0598c05361c767a75d6e1541"

  head "https://github.com/alanxz/rabbitmq-c.git"

  bottle do
    cellar :any
    sha1 "7637f895726ed8e597c02b616ba7f9a27109da91" => :mavericks
    sha1 "e9b5682c5fe0d5e5dfec55ce4c3f0957182755b1" => :mountain_lion
    sha1 "4ae0eb86504082c622c642f3c27f6361d0af4fad" => :lion
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

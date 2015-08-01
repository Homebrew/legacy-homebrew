class Pegtl < Formula
  desc "Parsing Expression Grammar Template Library"
  homepage "https://github.com/ColinH/PEGTL"
  url "https://github.com/ColinH/PEGTL/archive/1.1.0.tar.gz"
  sha256 "7131df800d4647610c68cb120c58fb34ede9adfad741c502785cdfe8aab698db"

  def install
    include.install "pegtl.hh", "pegtl"
    pkgshare.install "examples"
  end

  test do
    system ENV.cxx, pkgshare/"examples/hello_world.cc", "-std=c++11", "-stdlib=libc++", "-lc++", "-o", "helloworld"
    assert_equal "Good bye, homebrew!\n", shell_output("./helloworld 'Hello, homebrew!'")
  end
end
